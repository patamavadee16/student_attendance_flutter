
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:student_attendance/classifier/classifier_quant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../classifier/classifier.dart';
import '../classifier/vision_adapter.dart';

class form extends StatefulWidget {
  const form({super.key});

  @override
  State<form> createState() => _formState();
}

class _formState extends State<form> {
  late Classifier _classifier;
  File? _imageFile;
  bool isLoading = false;
  ui.Image? _image;
  Image? _imageWidget;
  final picker = ImagePicker();
  VisionAdapter _vision = VisionAdapter();
  TfResult? tflite;
   @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF3ED),
      appBar: AppBar(
        backgroundColor: Color(0xFFEDAB94),
        
        title: const Row(
          children: [
            Icon(Icons.checklist_rtl,size: 40,color: Colors.brown,),
            SizedBox(width: 10,),
            Text("เช็คชื่อเข้าเรียน",style: TextStyle(color: Colors.brown),),
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
        onPressed:_getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo ,
          color: const ui.Color.fromARGB(255, 255, 255, 255),),
        backgroundColor: const ui.Color.fromARGB(245, 240, 97, 5),
    ),
       body: isLoading
        ? Center(
          child: CircularProgressIndicator())
        : (_image == null)
        ? Center(child: Text('no image selected'))
        : Center(
          child:  
          // Container(
          //           constraints: BoxConstraints(
          //               maxHeight: MediaQuery.of(context).size.height / 2),
          //           decoration: BoxDecoration(
          //             border: Border.all(),
          //           ),
          //           child: _imageWidget,
          //         ),
          FittedBox(
          
            child: SizedBox(
              width: _image!.width.toDouble(),
              height: _image!.height.toDouble(),
              child: CustomPaint(
                painter: VisionPainter(_vision,Size(349,349),Size(411, 866.0),_image!),
              ),
            ),
          ),
        )
    );
  }
  Future<void> requestPermission() async {
    const permission = Permission.storage;  
    if (await permission.isDenied) {
      print("object");
      await permission.request();
    }
  }  
_getImage() async {
    requestPermission();
    print("get image");
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState((){
	    isLoading = true;
        // _loadImage(File(pickedFile!.path));
	});
    // print("Image picker file path - ${pickedFile!.path}");
      // _imageFile = File(pickedFile!.path);
      //  await _loadImage(File(pickedFile!.path));
        //      _imageFile = File(pickedFile!.path);
             
        // _loadImage(File(pickedFile!.path));
 
 if (mounted) {
      setState(() {
        _imageFile = File(pickedFile!.path);
        _loadImage(File(pickedFile!.path));
        

      });
    }

  }
  _loadImage(File file) async { 
    print("load image funtion");
	  final data = await file.readAsBytes();
    	  await decodeImageFromList(data).then((value) => setState((){
    // final start = DateTime.now().millisecondsSinceEpoch ;


      isLoading = true;
		  _image = value;
      _onDetect(File(file.path));
        // final stop = DateTime.now().millisecondsSinceEpoch-start ;
        //     print('Time to run model senet_model_size.tflite $stop ms');
        //     print('$isLoading');
		}));
	  // await decodeImageFromList(data).then((value) => setState(() async{
    // final start = DateTime.now().millisecondsSinceEpoch ;


    //   isLoading = true;
		//   _image = value;
    //    await _onDetect(File(file.path));
    //     final stop = DateTime.now().millisecondsSinceEpoch-start ;
    //         print('Time to run model senet_model_size.tflite $stop ms');
    //         print('$isLoading');
		// }));
}
  _onDetect(File _pictureFile) async {
    try {
        //  _imageFile= File(_pictureFile!.path);
        // _imageWidget = Image.file( _imageFile!);
        // img.Image imageInput = img.decodeImage(_imageFile!.readAsBytesSync())!;
        // await _classifier.predict(imageInput);
        await _vision.detect(_pictureFile);
        // var labellist = _vision.multiLabel;
        // print(labellist);
    } on Exception catch (e) {
      print('-- Exception ' + e.toString());
    }
    setState(() {
      isLoading = false;
       
    });
  }
}
