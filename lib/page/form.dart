import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:math';
// import 'package:image/image.dart' as img;
import 'package:student_attendance/classifier/classifier_quant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../classifier/classifier.dart';
import '../classifier/vision_adapter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
class form extends StatefulWidget {
  const form({super.key});
  @override
  State<form> createState() => _formState();
}

class _formState extends State<form> {
  String dropdownValue = '0';
  String subject = ' ';
  late Classifier _classifier;
  List<Map> student1 = [];
  List<Map> student2 = [];
  List<Map> student3 = [];
  bool isLoading = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  bool isSelected = false;
  ui.Image? _image1;
  ui.Image? _image2;
  ui.Image? _image3;
  File? _file1;
  File? _file2;
  File? _file3;
  List<String> multiLabel = [];
  final picker = ImagePicker();
  VisionAdapter _vision = VisionAdapter();
  TfResult? tflite;
  final List _course = [];
  String courseSelected = '';
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
        courseItems.add(const DropdownMenuItem(value: '0', child: Text('เลือกวิชา')));
        for (int code = 0; code < _course.length; code++) {
          courseItems.add(DropdownMenuItem(
              value: _course[code]['id'],
              child: Text(_course[code]['titleTH'] + ' sec ' + _course[code]['sec'])));
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
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFEDAB94),
      //   title: const Row(
      //     children: [
      //       Icon(
      //         Icons.checklist_rtl,
      //         size: 40,
      //         color: Colors.brown,
      //       ),
      //       SizedBox(
      //         width: 10,
      //       ),
      //       Text(
      //         "เช็คชื่อเข้าเรียน",
      //         style: TextStyle(color: Colors.brown),
      //       ),
      //     ],
      //   ),
      // ),
      //     floatingActionButton: FloatingActionButton(
      //     onPressed:_getImage,
      //     tooltip: 'Pick Image',
      //     child: Icon(Icons.add_a_photo ,
      //       color: const ui.Color.fromARGB(255, 255, 255, 255),),
      //     backgroundColor: const ui.Color.fromARGB(245, 240, 97, 5),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                      Container(
                          child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('FACE  RECOGNITION'),
                          Text('ATTENDANCE')
                        ],
                      )),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                // for ( var i in _products) Text(i.toString()),
                SizedBox(
                  child: Column(
                    children: [
                      DropdownButtonFormField(
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
                              print(codeValue);
                              dropdownValue = codeValue;
                              if(dropdownValue=='0'){
                                isSelected=false;
                              }else
                              isSelected=true;
                            });
                          }
                        },
                        isExpanded: false,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      isSelected?Column(
                        children: [
                          const Text('ครั้งที่ XX'),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFFFDF3ED),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ui.Color.fromARGB(
                                            255, 255, 255, 255), //<-- SEE HERE
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              child: SizedBox(
                                                  width:
                                                      _image1!.width.toDouble(),
                                                  height:
                                                      _image1!.height.toDouble(),
                                                  child: CustomPaint(
                                                    painter: VisionPainter(
                                                        _vision,
                                                        Size(349, 349),
                                                        Size(411, 866.0),
                                                        _image1!,
                                                        '1'),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 200,
                                              child: 
                                              ListView.separated(
                                                              scrollDirection:Axis.vertical,
                                                              separatorBuilder:(context,index) {
                                                                return const Divider();
                                                              },
                                                              itemCount:student1.length,
                                                              itemBuilder:(BuildContextcontext,int index) {
                                                                return Text('${index + 1}.${student1[index]['std']} ${student1[index]['name']}',
                                                                  style: const TextStyle(
                                                                  fontSize:15),
                                                                );
                                                              })
                                              // SingleChildScrollView(
                                              //   child: Column(
                                              //     crossAxisAlignment:
                                              //         CrossAxisAlignment.start,
                                              //     children: List.generate(
                                              //         _vision.multiLabel.length,
                                              //         (index) {
                                              //       return Text(
                                              //         (index + 1).toString() +
                                              //             '. ' +
                                              //             _vision
                                              //                 .multiLabel[index]
                                              //                 .toString(),
                                              //         style: const TextStyle(
                                              //             fontSize: 20),
                                              //       );
                                              //     }),
                                              //   ),
                                              // ),
                                            ),
                                          ],
                                        )),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                              child: isLoading2
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFFEDAB94),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ui.Color.fromARGB(
                                            255, 255, 255, 255), //<-- SEE HERE
                                      ),
                                    ))
                                  : (_image2 == null)
                                      ? Center(
                                          child: SizedBox(
                                              height: 120,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: pickImageBtn(context, '2')))
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              child: SizedBox(
                                                  width:
                                                      _image2!.width.toDouble(),
                                                  height:
                                                      _image2!.height.toDouble(),
                                                  child: CustomPaint(
                                                    painter: VisionPainter(
                                                        _vision,
                                                        Size(349, 349),
                                                        Size(411, 866.0),
                                                        _image2!,
                                                        '2'),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 200,
                                              child: ListView.separated(
                                                              scrollDirection:Axis.vertical,
                                                              separatorBuilder:(context,index) {
                                                                return const Divider();
                                                              },
                                                              itemCount:student2.length,
                                                              itemBuilder:(BuildContextcontext,int index) {
                                                                return Text('${index + 1}.${student2[index]['std']} ${student2[index]['name']}',
                                                                  style: const TextStyle(
                                                                  fontSize:15),
                                                                );
                                                              })
                                              //  SingleChildScrollView(
                                              //   child: Column(
                                              //     crossAxisAlignment:
                                              //         CrossAxisAlignment.start,
                                              //     children: List.generate(
                                              //         _vision.multiLabel2.length,
                                              //         (index) {
                                              //       return Text(
                                              //         (index + 1).toString() +
                                              //             '. ' +
                                              //             _vision
                                              //                 .multiLabel2[index]
                                              //                 .toString(),
                                              //         style: const TextStyle(
                                              //             fontSize: 20),
                                              //       );
                                              //     }),
                                              //   ),
                                              // ),
                                            ),
                                          ],
                                        )),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                              child: isLoading3
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFFEDAB94),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ui.Color.fromARGB(
                                            255, 255, 255, 255), //<-- SEE HERE
                                      ),
                                    ))
                                  : (_image3 == null)
                                      ? Center(
                                          child: SizedBox(
                                              height: 120,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: pickImageBtn(context, '3')))
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              child: SizedBox(
                                                  width:
                                                      _image3!.width.toDouble(),
                                                  height:
                                                      _image3!.height.toDouble(),
                                                  child: CustomPaint(
                                                    painter: VisionPainter(
                                                        _vision,
                                                        Size(349, 349),
                                                        Size(411, 866.0),
                                                        _image3!,
                                                        '3'),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 200,
                                              child:
                                                ListView.separated(
                                                              scrollDirection:Axis.vertical,
                                                              separatorBuilder:(context,index) {
                                                                return const Divider();
                                                              },
                                                              itemCount:student3.length,
                                                              itemBuilder:(BuildContextcontext,int index) {
                                                                return Text('${index + 1}.${student3[index]['std']} ${student3[index]['name']}',
                                                                  style: const TextStyle(
                                                                  fontSize:15),
                                                                );
                                                              })
                                              )
                                            ]),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 96, 255, 157)
                                              .withOpacity(0.9),
                                      onPrimary:
                                          Color.fromARGB(255, 255, 255, 255),
                                      // backgroundColor: Color(0xFFFDF3ED).withOpacity(0.9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: uploadPic,
                                    label: const Text(
                                      "ยืนยัน",
                                      style: TextStyle(fontSize: 20),
                                    ), //label text
                                    icon: Icon(Icons.check)),
                              ],
                            )
                          : Text('โปรดเลือกรายวิชา')
                    ],
                  ),
                ),
              ]),
            ),
          ))
        ],
      ),
      //  isLoading
      //   ? Center(
      //     child: CircularProgressIndicator())
      //   : (_image == null)
      //   ? Center(child: Text('no image selected'))
      //   :
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           FittedBox(
      //                       child:
      //                           SizedBox(
      //                             width: _image!.width.toDouble(),
      //                             height: _image!.height.toDouble(),
      //                             child:
      //                                     CustomPaint(
      //                                       painter: VisionPainter(_vision,Size(349,349),Size(411, 866.0),_image!),
      //                                     )
      //                           ),
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: List.generate(_vision.multiLabel.length, (index) {
      //     return Text((index+1).toString()+' '+
      //       _vision.multiLabel[index].toString(),
      //       style: const TextStyle(fontSize: 20),
      //     );
      //   }),
      // ),

      //         ],

      //   )
    );
  }
  // Future<Widget> fetchStudennt3() async {
  //   for (int i = 0; i < _vision.multiLabel3.length; i++) {
  // QuerySnapshot qn = await _firestoreInstance
  //      .collection('course')
  //           .doc('ZAby5d4EbPj8vyfEgwRk')
  //           .collection('students')
  //           .where('studentId', isEqualTo: _vision.multiLabel3[i])
  //           .get();
  //        }
  //           // .collection('course')
  //           // .doc('ZAby5d4EbPj8vyfEgwRk')
  //           // .collection('students')
  //           // .where('studentId', isEqualTo: _vision.multiLabel3[index])
  //           // .get();
  //   if (mounted) {
  //     setState(() {
  //       // for (int i = 0; i < qn.docs.length; i++) {
  //       //   student.add({
  //       //     'id': qn.docs[i].id,
  //       //     "name": qn.docs[i]["name"],
  //       //     "stdId": qn.docs[i]['studentId'],
  //       //     'no': qn.docs[i]['no'],
  //       //     //.attendance': qn.docs[i]['attendance'].values
  //       //     //.reduce((sum, value) => sum + value),
  //       //   });
  //       //   print(_vision.multiLabel3.length);
  //       // }
           
  //     });
  //   }
    
  //   return ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       shrinkWrap: true,
  //       itemCount: student.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Text(
  //           student[index]['stdId'] + index.toString(),
  //         );
  //       });

  //   // Text('data');
  // }
  // StreamBuilder<QuerySnapshot<Object?>> fetchStudent(int index) {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection('course')
  //           .doc('ZAby5d4EbPj8vyfEgwRk')
  //           .collection('students')
  //           .where('studentId', isEqualTo: _vision.multiLabel3[index])
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           const CircularProgressIndicator();
  //         } else {
           
  //           final codeItem = snapshot.data?.docs.reversed.toList();

  //           for (var code in codeItem!) {
  //             student.add({
  //               'id': code.id,
  //               "name": code["name"],
  //               "stdId": code['studentId'],
  //               'no': code['no'],
  //               //.attendance': qn.docs[i]['attendance'].values
  //               //.reduce((sum, value) => sum + value),
  //             });
  //             print(index);
  //             print(student[index]['name']);
  //           }
  //         }
  //         return Text(
  //           '${index + 1}.${student[index]['name']}',
  //           style: const TextStyle(fontSize: 20),
  //         );
  //       });
  // }

  StreamBuilder<QuerySnapshot<Object?>> dropdown() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('course')
            .where('teacher', isEqualTo: 'อาจารย์.ดร.พิชยพัชยา ศรีคร้าม')
            .snapshots(),
        builder: (context, snapshot) {
          List<DropdownMenuItem> codeItems = [];
          if (!snapshot.hasData) {
            const CircularProgressIndicator();
          } else {
            final codeItem = snapshot.data?.docs.reversed.toList();
            codeItems.add(
                const DropdownMenuItem(value: '0', child: Text('เลือกวิชา')));
                      //  print(codeItem);
            for (var code in codeItem!) {
              codeItems.add(DropdownMenuItem(
                  value: code.id,
                  child: Text(code['titleTH'] + ' sec ' + code['sec'])));
            }
     
          }
          return SizedBox(
            child: Column(
              children: [
                DropdownButtonFormField(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                  items: codeItems,
                  value: dropdownValue,
                  onChanged: (codeValue) {
                    if (mounted) {
                      setState(() {
                        dropdownValue = codeValue;

                        // print(dropdownValue);
                 
                        // subject = codeValue['titleTH'];
                      });
                    }
                  },
                  isExpanded: false,
                ),
              ],
            ),
          );
        });
  }

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

  addUser() {
    FirebaseFirestore.instance
        .collection('course')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["code"]);
      });
    });

    // .then((value) => print("User added successfully!"))
    // .catchError((error) => print("Failed to add user: $error"));
  }

  Future uploadPic() async {
    Random random = Random();
    int i = random.nextInt(100);
    final path = 'ProfilePicture/$i.jpg';
    final ref = FirebaseStorage.instance.ref().child(path);
    final storageUpload1 = ref.putFile(_file1!);
    final storageUpload2 = ref.putFile(_file2!);
    final storageUpload3 = ref.putFile(_file3!);
    print('$path');
    print('pic$i.jpg');
    //   final snapshot = await storageUploadTask.whenComplete(() {});

    // final urlPicture = await snapshot.ref.getDownloadURL();
    // print('$urlPicture');
    // updateData(urlPicture);
  }

  Future<Widget> fetcht() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(dropdownValue)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
      }
    });
    // if (mounted) {
    //   setState(() {
    //     // student.clear();
    //     for (int i = 0; i < qn.docs.length; i++) {
    //       student.add({
    //         'id': qn.docs[i].id,
    //         "name": qn.docs[i]["name"],
    //         "stdId": qn.docs[i]['studentId'],
    //         'no': qn.docs[i]['no'],
    //         //.attendance': qn.docs[i]['attendance'].values
    //         //.reduce((sum, value) => sum + value),
    //       });
    //       // print(student);
    //     }
    //   });
    // }

    return Text('data');
    // Text('data');
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
// _getImage() async {
//     requestPermission();
//     print("get image");
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     setState((){
// 	    isLoading = true;
// 	});

//  if (mounted) {
//       setState(() {
//         _imageFile = File(pickedFile!.path);

//         _loadImage(File(pickedFile!.path));

//       });
//     }

//   }
//   _getImageC() async {
//     requestPermission();
//     print("get image");
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
//     setState((){
// 	    isLoading = true;
// 	});

//  if (mounted) {
//       setState(() {
//         _imageFile = File(pickedFile!.path);

//         _loadImage(File(pickedFile!.path));

//       });
//     }

//   }
//   _getImageCamera(String no) async {
//     requestPermission();
//     print("get image");
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
//     setState((){
// 	    isLoading = true;
// 	});

//  if (mounted) {
//       setState(() {

//         // _imageFile = File(pickedFile!.path);

//        final  a =  _loadImageP(File(pickedFile!.path));

//       });
//     }

//   }

//   Future< ui.Image?>  _loadImageP(File file) async {
//  final data = await file.readAsBytes();
//   ui.Image? _image1;
//     	  await decodeImageFromList(data).then((value) => setState((){
//       isLoading = true;
//   _image1 = value;

//       _onDetect(File(file.path));
//       }));
//       return  _image1 ;
//     print("load image funtion");
// 	  final data = await file.readAsBytes();
//     	  await decodeImageFromList(data).then((value) => setState((){
//       isLoading = true;

//   _image = value;

//       _onDetect(File(file.path));

// 		}));

// }

//   _getImage2() async {
//     requestPermission();
//     print("get image");
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     setState((){
// 	    isLoading2 = true;
// 	});

//  if (mounted) {
//       setState(() {
//         _imageFile = File(pickedFile!.path);

//         _loadImage2(File(pickedFile!.path));

//       });
//     }

//   }
//     _getImage3() async {
//     requestPermission();
//     print("get image");
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     setState((){
// 	    isLoading3 = true;
// 	});

//  if (mounted) {
//       setState(() {
//         _imageFile = File(pickedFile!.path);

//         _loadImage3(File(pickedFile!.path));

//       });
//     }

//   }
//   _loadImage(File file) async {
//     print("load image funtion");
// 	  final data = await file.readAsBytes();
//     	  await decodeImageFromList(data).then((value) => setState((){
//       isLoading = true;

//   _image1 = value;

//       _onDetect(File(file.path));

// 		}));

// }  _loadImage2(File file) async {
//     print("load image funtion");
// 	  final data = await file.readAsBytes();
//     	  await decodeImageFromList(data).then((value) => setState((){
//       isLoading2 = true;

//   _image2 = value;

//       _onDetect2(File(file.path));

// 		}));

// }
//   _loadImage3(File file) async {
//     print("load image funtion");
// 	  final data = await file.readAsBytes();
//     	  await decodeImageFromList(data).then((value) => setState((){
//       isLoading3 = true;

//   _image3= value;

//       _onDetect3(File(file.path));

// 		}));

// }

  // _onDetect2(File _pictureFile) async {
  //   try {
  //       await _vision.detect(_pictureFile,'2');
  //   } on Exception catch (e) {
  //     print('-- Exception ' + e.toString());
  //   }
  //   setState(() {
  //     isLoading2 = false;

  //   });
  // }
  // _onDetect3(File _pictureFile) async {
  //   try {
  //       await _vision.detect(_pictureFile,'3');
  //   } on Exception catch (e) {
  //     print('-- Exception ' + e.toString());
  //   }
  //   setState(() {
  //     isLoading3 = false;

  //   });
  // }

