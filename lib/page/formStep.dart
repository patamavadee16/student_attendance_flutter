import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_attendance/classifier/classifier_quant.dart';
import '../classifier/classifier.dart';
import '../classifier/vision_adapter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  final picker = ImagePicker();
  VisionAdapter _vision = VisionAdapter();
  TfResult? tflite;
  ui.Image? _image1;
  ui.Image? _image2;
  ui.Image? _image3;
  File? _file1;
  File? _file2;
  File? _file3;
  List<Map> student1 = [];
  List<Map> student2 = [];
  List<Map> student3 = [];
  bool isLoading = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  int currentStep = 0;
  bool isSelected = false;
  String dropdownValue = '0';
  Map<String, dynamic> _courseed ={};
  late Classifier _classifier;
  final List _course = [];
  List<DropdownMenuItem> courseItems = [];
  final _firestoreInstance = FirebaseFirestore.instance;
  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance
        .collection('course')
        .where('teacher', isEqualTo: 'อาจารย์.ดร.พิชยพัชยา ศรีคร้าม')
        .get();
    if (mounted) {
      setState(() {
        for (int i = 0; i < qn.docs.length; i++) {
          _course.add({
            'id': qn.docs[i].id,
            "code": qn.docs[i]["code"],
            "sec": qn.docs[i]['sec'],
            'titleTH': qn.docs[i]['titleTH'],
            'titleEng': qn.docs[i]['titleEng'],
            'teacher': qn.docs[i]['teacher']
          });
        }
        courseItems
            .add(const DropdownMenuItem(value: '0', child: Text('เลือกวิชา')));
        for (int code = 0; code < _course.length; code++) {
          courseItems.add(DropdownMenuItem(
              value: _course[code]['id'],
              
              child: Text(
                  _course[code]['titleTH'] + ' sec ' + _course[code]['sec'],  overflow: TextOverflow.ellipsis)));
        }
      });
    }
    return qn.docs;
  }
  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDAB94),
      body:  Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: ui.Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 70,
                        height: 60,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text('FACE  RECOGNITION'),
                      Text('ATTENDANCE')
                        ],
                      ),
                    ],
                  )),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFFEDAB94),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 30,
                    ),
                    title: const Text(
                      'เช็คชื่อเข้าเรียน',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Color(0xFFFDF3ED),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35))),
                child: SizedBox(

                  height: MediaQuery.of(context).size.height - 20,
                  child: Stepper(
                      type: StepperType.horizontal,
                      steps: getSteps(),
                      currentStep: currentStep,
                      onStepContinue: () {
                        final isLastStep =currentStep == getSteps().length - 1;
                        if (isLastStep) {
                          print('complete');
                        } else {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      },
                      onStepCancel: currentStep == 0
                          ? null
                          : () => setState(() {
                                currentStep -= 1;
                              })),
                )),
          )
        ],
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
            isActive: currentStep >= 0,
            state:currentStep  ==  0 ?StepState.indexed : StepState.complete,
            title: Text(''),
            
            label:Text(currentStep  ==  0 ?'เลือกรายวิชา':''),
            // subtitle: Text('เช็คชื่อเข้าเรียน'),
            content:  DropdownButtonFormField(

              isExpanded: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 1),
                        borderRadius: BorderRadius.circular(12.0),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(
                                color: ui.Color.fromARGB(255, 255, 255, 255),
                                width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(
                                color: ui.Color.fromARGB(255, 255, 255, 255),
                                width: 3),
                          ),
                        ),
                        items: courseItems,
                        value: dropdownValue,
                        onChanged: (codeValue) {
                          if (mounted) {
                            setState(() {
                              dropdownValue = codeValue;
                              if(dropdownValue=='0'){
                                
                                isSelected=false;
                              }else {
                                for (int i = 0; i < _course.length; i++) {
                                    if(_course[i]['id']==dropdownValue){
                                      _courseed=_course[i];
                                      print(_courseed['titleTH']);
                                    }
                                }
                                currentStep=1;
                                isSelected=true;
                              }
                            });
                          }
                        },
                        
                      ),
            ),
        Step(
            isActive: currentStep >= 1,
            state: currentStep == 1 ? StepState.indexed : StepState.complete,
            label: Text(currentStep == 1 ? 'อัปโหลดรูปภาพ' : ''),
            title: Text(""),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(isSelected
                      ? _courseed['titleTH'] + ' กลุ่ม ' + _courseed['sec']
                      : ''),
                  Text('ครั้งที่ XX'),
                                            Container(
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFFFDF3ED),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ui.Color.fromARGB(
                                            255, 255, 255, 255), 
                                      ),
                                    ))
                                  : (_image1 == null)
                                      ? Center(
                                          child: SizedBox(
                                              height: 120,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: pickImageBtn(context, '1')))
                                      : Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                                    child: InteractiveViewer(
                                                      panEnabled:true, // Set it to false
                                                      minScale: 0.5,
                                                      maxScale: 2,
                                                child: SizedBox(
                                                    width:_image1!.width.toDouble(),
                                                    height:_image1!.height.toDouble(),
                                                    child: CustomPaint(
                                                      painter: VisionPainter(_vision,Size(349, 349),Size(411, 866.0),_image1!,'1'),
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 200,
                                              child: ListView.separated(
                                                      scrollDirection:Axis.vertical,
                                                      separatorBuilder:(context,index) {
                                                        return const Divider();
                                                      },
                                                      itemCount:student1.length,
                                                      itemBuilder:(BuildContextcontext,int index) {
                                                        return Text('${index + 1}.${student1[index]['std']} ${student1[index]['name']}',
                                                                  style: const TextStyle(fontSize:15),
                                                                );
                                                      })
                                            ),
                                          ],
                                        )),
                ],
              ),
            )),
        Step(
            isActive: currentStep >= 2, 
            state:currentStep  ==  2 ?StepState.indexed : StepState.complete,
            title: Text(''), 
            label:Text(currentStep  ==  2 ?'บันทึก':''),
            content: Container()),
      ];
  ElevatedButton pickImageBtn(BuildContext context, String no) {
    return ElevatedButton(
      onPressed: () => _showSelectionDialog(context, no),
      style: ElevatedButton.styleFrom(
        primary: ui.Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
        onPrimary: const Color(0xFFEDAB94),
        // backgroundColor: Color(0xFFFDF3ED).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Container(
        child: Row(
          children: [
            Image.asset(
              'assets/pic.png',
              width: 70,
              height: 150,
            ),
            SizedBox(
              width: 50,
            ),
            Text('เลือกรูปภาพที่ $no', style: TextPickStyle())
          ],
        ),
      ),
    );
  }

  TextStyle TextPickStyle() => TextStyle(
        color: Colors.black,
        fontSize: 20,
      );

  Future<void> _showSelectionDialog(BuildContext context, no) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15)),
              backgroundColor: ui.Color.fromARGB(220, 255, 255, 255),
              title: Text("Select image"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _pickGallery(context, no);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () => _pickCamera(context, no),
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> requestPermission() async {
    const permission = Permission.storage;
    if (await permission.isDenied) {
      await permission.request();
    }
  }

  Future<void> _pickCamera(BuildContext context, String no) async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);

      final image = await loadImage(File(pickedFile!.path), no);

      setState(() {
        if (no == '1') {
          _image1 = image;
        } else if (no == '2') {
          _image2 = image;
        } else if (no == '3') {
          _image3 = image;
        }
      });
      Navigator.of(context).pop();
    } catch (e) {}
  }

  Future<void> _pickGallery(BuildContext context, String no) async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      print('course');

      final image = await loadImage(File(pickedFile!.path), no);
      setState(() {
        if (no == '1') {
          _image1 = image;
        } else if (no == '2') {
          _image2 = image;
        } else if (no == '3') {
          _image3 = image;
        }
      });
      Navigator.of(context).pop();
    } catch (e) {}
  }

  Future<ui.Image?> loadImage(File file, String no) async {
    ui.Image? image;
    try {
      final data = await file.readAsBytes();
      await decodeImageFromList(data).then((value) => setState(() {
            if (no == '1') {
              isLoading = true;
            } else if (no == '2') {
              isLoading2 = true;
            } else if (no == '3') {
              isLoading3 = true;
            }
            image = value;
            _onDetect(File(file.path), no);
          }));
    } on Exception catch (e) {
      print('-- Exception ' + e.toString());
    }
    return image;
    // setState(() => imageStateVarible = image);
  }

  _onDetect(File _pictureFile, String no) async {
    try {
      if (no == '1') {
        await _vision.detect(_pictureFile, '1');
        await fetchID();
      } else if (no == '2') {
        await _vision.detect(_pictureFile, '2');
        await fetchID2();

      } else if (no == '3') {
        await _vision.detect(_pictureFile, '3');
        await fetchID3();
      }
    } on Exception catch (e) {
      print('-- Exception ' + e.toString());
    }
    setState(() {
      if (no == '1') {
        isLoading = false;
      } else if (no == '2') {
        isLoading2 = false;
      } else if (no == '3') {
        isLoading3 = false;
      }
    });
  }
  fetchID() async {
    for (int i = 0; i < _vision.multiLabel.length; i++) {
      QuerySnapshot qn = await _firestoreInstance
          .collection('course')
          .doc(dropdownValue)
          .collection('students')
          .where('studentId', isEqualTo: _vision.multiLabel[i])
          .get();
      // print(i);
      // print(_vision.multiLabel[i]);
      for (int i = 0; i < qn.docs.length; i++) {
        student1.add({
          'id': qn.docs[0].id,
          "std": qn.docs[0]["studentId"],
          "name": qn.docs[0]['name'],
        });
      }
      // return qn.docs;
    }
  }
  fetchID2() async {
    for (int i = 0; i < _vision.multiLabel2.length; i++) {
      QuerySnapshot qn = await _firestoreInstance
          .collection('course')
          .doc(dropdownValue)
          .collection('students')
          .where('studentId', isEqualTo: _vision.multiLabel2[i])
          .get();
      for (int i = 0; i < qn.docs.length; i++) {
        student2.add({
          'id': qn.docs[0].id,
          "std": qn.docs[0]["studentId"],
          "name": qn.docs[0]['name'],
        });
      }
    }
  }
  fetchID3() async {
    for (int i = 0; i < _vision.multiLabel3.length; i++) {
      QuerySnapshot qn = await _firestoreInstance
          .collection('course')
          .doc(dropdownValue)
          .collection('students')
          .where('studentId', isEqualTo: _vision.multiLabel3[i])
          .get();
      print(i);
      print(_vision.multiLabel3[i]);
      for (int i = 0; i < qn.docs.length; i++) {
        student3.add({
          'id': qn.docs[0].id,
          "std": qn.docs[0]["studentId"],
          "name": qn.docs[0]['name'],
        });
      }
    }
  }
}
