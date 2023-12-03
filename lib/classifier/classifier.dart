import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

abstract class Classifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  List<String> _labels = [];
  static int _inputSize = 224;
  bool init = false;
  late List<int> _inputShape;
  Map<int, ByteBuffer> _outputBuffers = new Map<int, ByteBuffer>();
  Map<int, TensorBuffer> _outputTensorBuffers = new Map<int, TensorBuffer>();
  Map<int, String> _outputTensorNames = new Map<int, String>();
  String get modelName;
  late var _probabilityProcessor;
  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;
  List<int> sumTime = [];

  Classifier({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();
    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

  }

  Future<bool> initModel() async {
    if(init)
      return true;
    try {
      interpreter = await Interpreter.fromAsset(modelName);
      final outputTensors = interpreter.getOutputTensors();
      // _inputShape = interpreter.getInputTensor(0).shape;
      // _outputShape = interpreter.getOutputTensor(0).shape;
      // _inputType = interpreter.getInputTensor(0).type;
      // _outputType = interpreter.getOutputTensor(0).type;
      // TensorBuffer output = TensorBuffer.createFixedSize(tensor.shape, tensor.type);
      outputTensors.asMap().forEach((i, tensor) {
        TensorBuffer output = TensorBuffer.createFixedSize(tensor.shape, tensor.type);
        _outputTensorBuffers[i] = output;
        _outputBuffers[i] = output.buffer;
        _outputTensorNames[i] = tensor.name;
      });

      _inputShape = interpreter.getInputTensor(0).shape;
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
      /// load labels
      final labelData = await rootBundle.loadString('assets/labelscpe.txt');
      final labelList = labelData.split('\n');
      _labels = labelList;
      init = true;
    } on Exception catch (e) {
      print('-- initModel '+e.toString());

    }
    return init;
  }

  // square image
  TensorImage getProcessedImage(TensorImage inputImage) {
    int cropSize = min(inputImage.height, inputImage.width);
    ImageProcessor? imageProcessor = ImageProcessorBuilder()
      // .add(ResizeWithCropOrPadOp(cropSize, cropSize)) // Center crop
      .add(ResizeOp(_inputSize, _inputSize,ResizeMethod.BILINEAR))
      .add(preProcessNormalizeOp) // Resize 224x224
    .build();
    return imageProcessor.process(inputImage);
  }

  Future<TfResult> predict(Image image) async {
    if (await initModel() == false) {
      return TfResult();
    }
    TfResult res = TfResult();
    try {
      TensorImage _inputImage = TensorImage(interpreter.getInputTensor(0).type);
      _inputImage.loadImage(image);
      _inputImage = getProcessedImage(_inputImage);
      res = await run(_inputImage);

    } on Exception catch (e) { 
    }
    return res;
  }
    Future<TfResult> run(TensorImage inputImage) async {
    final runs = DateTime.now().millisecondsSinceEpoch;
    TfResult res = TfResult();
    try {
      final inputs = [inputImage.buffer];
      interpreter.runForMultipleInputs(inputs, _outputBuffers); // RUN
      for (int i = 0; i < _outputTensorBuffers.length; i++) {
        TensorBuffer buffer = _outputTensorBuffers[i]!;
        for (int j = 0; j < buffer.getDoubleList().length; j++) {
          TfOutput r = TfOutput();
          r.label = _labels.length>j ? _labels[j] : '-';
          r.score = buffer.getDoubleList()[j];
          res.outputs.add(r);
            Map<String, double> labeledProb = TensorLabel.fromList(
            _labels, _probabilityProcessor.process(_outputTensorBuffers[0]))
        .getMapWithFloatValue();
        }
      }
    } on Exception catch (e) {
    }
    res.outputs.sort((b,a) => a.score.compareTo(b.score));
    print('-- '+res.outputs[0].score.toString()+' '+res.outputs[0].label);
    return res;
    
  }
}

/// TensorFlow Result
class TfOutput {
  double score = 0.0;
  String label = "";
}
class TfResult {
  List<TfOutput> outputs = [];
  Rect rect = Rect.fromLTWH(0,0,0,0);
  List<TfOutput> get loutputs {
    return outputs;
  }
}
MapEntry<String, double> getTopProbability(Map<String, double> labeledProb) {
  var pq = PriorityQueue<MapEntry<String, double>>(compare);
  pq.addAll(labeledProb.entries);
  // print(pq.first);  
  return pq.first;
}

int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
  if (e1.value > e2.value) {
    return -1;
  } else if (e1.value == e2.value) {
    return 0;
  } else {
    return 1;
  }
}