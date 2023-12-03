
import "dart:async";
import 'package:student_attendance/classifier/classifier.dart';
import 'package:student_attendance/classifier/classifier_quant.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import "package:image/image.dart" as imglib;
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';
bool isTest = false;
enum VisionType {
  NONE,
  FACE,
  FACE2,
  IMAGE,
  TENSOR,
  TENSOR2,
}
/// Google ML Kit Vision APIs
class VisionAdapter  {
  VisionType type = VisionType.TENSOR2;
  List<Face> faces = [];
  List<ImageLabel> labels = [];
  List<TfResult> results = [];
  List<TfResult> results2 = [];
  List<TfResult> results3 = [];

  late FaceDetector _faceDetector;
  late ImageLabeler _imageLabeler;
  Classifier? _tflite;
    List<String> multiLabel = [];
        List<String> multiLabel2 = [];
            List<String> multiLabel3 = [];

  VisionAdapter(){
    _faceDetector = FaceDetector(
      options:FaceDetectorOptions(
          enableClassification: true,
          enableLandmarks: true,
          enableContours: true,
          enableTracking: false,
          minFaceSize: 0.1,
          performanceMode: FaceDetectorMode.accurate),
    );


    _imageLabeler = ImageLabeler(
        options:ImageLabelerOptions(confidenceThreshold: 0.5)
    );
    _tflite =  ClassifierQuant();
  }

  void dispose() {
    if (_faceDetector != null) _faceDetector.close();
    if (_imageLabeler != null) _imageLabeler.close();
  }

  Future<void> detect(File imagefile,String no) async {
    try {
      if (await imagefile.exists()) {
        final inputImage = InputImage.fromFile(imagefile);

        if(type==VisionType.FACE || type==VisionType.FACE2) {
          faces = await _faceDetector.processImage(inputImage);

        } else if(type==VisionType.TENSOR2) {
          List<Rect> rects = [];
          faces = await _faceDetector.processImage(inputImage);
          for (Face f in faces) {
            rects.add(f.boundingBox);
          }
        if(no=='1'){
          results.clear();
          multiLabel.clear();
          final File cropfile = File('${(await getTemporaryDirectory()).path}/crop.jpg');
          final byteData = imagefile.readAsBytesSync();
          imglib.Image? srcimg = imglib.decodeImage(byteData);

          for (Rect r1 in rects) {
            r1 = r1.inflate(4.0);
            imglib.Image crop = imglib.copyCrop(srcimg!, r1.left.toInt(), r1.top.toInt(), r1.width.toInt(), r1.height.toInt());
            await cropfile.writeAsBytes(imglib.encodeJpg(crop));
            TfResult res = await _tflite!.predict(crop);
            res.rect = r1;
            if(res.outputs.length>0)
              results.add(res);
          }
         for (TfResult res in results) {
          
            String outputLabel = (res.outputs[0].score).toStringAsFixed(3).toString() + " " + res.outputs[0].label;
            multiLabel.add(res.outputs[0].label);


          }
        }else if(no=='2'){
                results2.clear();
          multiLabel2.clear();
          final File cropfile = File('${(await getTemporaryDirectory()).path}/crop.jpg');
          final byteData = imagefile.readAsBytesSync();
          imglib.Image? srcimg = imglib.decodeImage(byteData);

          for (Rect r1 in rects) {
            r1 = r1.inflate(4.0);
            imglib.Image crop = imglib.copyCrop(srcimg!, r1.left.toInt(), r1.top.toInt(), r1.width.toInt(), r1.height.toInt());
            await cropfile.writeAsBytes(imglib.encodeJpg(crop));
            TfResult res = await _tflite!.predict(crop);
            res.rect = r1;
            if(res.outputs.length>0)
              results2.add(res);
          }
         for (TfResult res in results2) {
          
            String outputLabel = (res.outputs[0].score).toStringAsFixed(3).toString() + " " + res.outputs[0].label;
            multiLabel2.add(res.outputs[0].label);


          }
        }else if(no=='3'){
                  results3.clear();
          multiLabel3.clear();
          final File cropfile = File('${(await getTemporaryDirectory()).path}/crop.jpg');
          final byteData = imagefile.readAsBytesSync();
          imglib.Image? srcimg = imglib.decodeImage(byteData);

          for (Rect r1 in rects) {
            r1 = r1.inflate(4.0);
            imglib.Image crop = imglib.copyCrop(srcimg!, r1.left.toInt(), r1.top.toInt(), r1.width.toInt(), r1.height.toInt());
            await cropfile.writeAsBytes(imglib.encodeJpg(crop));
            TfResult res = await _tflite!.predict(crop);
            res.rect = r1;
            if(res.outputs.length>0)
              results3.add(res);
          }
         for (TfResult res in results3) {
          
            String outputLabel = (res.outputs[0].score).toStringAsFixed(3).toString() + " " + res.outputs[0].label;
            multiLabel3.add(res.outputs[0].label);


          }
        }
        
        }
        
        print('-- END');
      }

    } on Exception catch (e) {
      print('-- Exception ' + e.toString());
    }
  }
}

class VisionPainter extends CustomPainter {
  final Color COLOR1 = Color.fromARGB(255, 156, 255, 129);
  late VisionAdapter vision;
  late Size cameraSize;
  late Size screenSize;
  double scale = 1.0;
  final ui.Image image;
  late String no;

 

  VisionPainter(VisionAdapter vision, Size cameraSize, Size screenSize,this.image,String no){
    this.vision = vision;
    this.cameraSize = cameraSize;
    this.screenSize = screenSize;
    this.no=no;
    
  }

  Paint _paint = Paint();
  late Canvas _canvas;
  double _textTop = 240.0;
  double _textLeft = 30.0;
  double _fontSize =40;
  double _fontHeight = 50;

  @override
  void paint(Canvas canvas, Size size){
    print("pain"+screenSize.height.toString()+screenSize.width.toString());
    _canvas = canvas;
    _paint.style = PaintingStyle.stroke;
    _paint.color = COLOR1;
    _paint.strokeWidth = 2.0;
                                                                                                                                                                     
if (vision.type == VisionType.TENSOR) {
      if (vision.results.length == 0)
        return;
      int i=0;
      for (TfResult res in vision.results) {
        for (TfOutput out in res.outputs) {
          String s = (out.score).toInt().toString() + " " + out.label;
          drawText(Offset(_textLeft, _textTop + _fontHeight * (i++)), s, _fontSize);
          if (i > 5) break;
        }
      }

    } else if (vision.type == VisionType.TENSOR2) {

            canvas.drawImage(image, Offset.zero, Paint());
            if(no=='1'){
            for (TfResult res in vision.results) {
            canvas.drawRect(res.rect, _paint);
            String outputLabel = (res.outputs[0].score).toStringAsFixed(3).toString() + " " + res.outputs[0].label;
            drawText(Offset(res.rect.left, res.rect.top - _fontHeight), outputLabel, _fontSize);

          }
            }else if(no=='2'){
                       for (TfResult res in vision.results2) {
            canvas.drawRect(res.rect, _paint);
            String outputLabel = (res.outputs[0].score).toStringAsFixed(3).toString() + " " + res.outputs[0].label;
            drawText(Offset(res.rect.left, res.rect.top - _fontHeight), outputLabel, _fontSize);

          }
            }else if(no=='3'){
                          for (TfResult res in vision.results3) {
            canvas.drawRect(res.rect, _paint);
            String outputLabel = (res.outputs[0].score).toStringAsFixed(3).toString() + " " + res.outputs[0].label;
            drawText(Offset(res.rect.left, res.rect.top - _fontHeight), outputLabel, _fontSize);

          }
            }

      }


  }
  /// Rect
  // drawRect(Rect? r) {
  //   print(r);
  //   if(r==null) return;
  //   _paint.style = PaintingStyle.stroke;
  //   _canvas.drawRect(r, _paint);
  //   print(r.top);
  //   print("rect");
    
  // }

  /// Draw text
  drawText(Offset offset, String text, double size) {
    TextSpan span = TextSpan(
      text: " "+text+" ",
      style: TextStyle(color: COLOR1, backgroundColor: Color.fromARGB(133, 60, 60, 60), fontSize: size),
    );
    final textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(_canvas, offset);  
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
