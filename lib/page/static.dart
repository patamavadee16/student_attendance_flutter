import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';

class staticPage extends StatefulWidget {
  const staticPage({super.key});

  @override
  State<staticPage> createState() => _staticPageState();
}

class _staticPageState extends State<staticPage> {
  String dropdownValue = 'start';
  bool isDownload = false;
  final List _course = [];
  final List student = [];
  String subject = "";
  bool isSelect = false;
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
            .add(const DropdownMenuItem(value: 'start', child: Text('เลือกวิชา')));
        for (int code = 0; code < _course.length; code++) {
          // print(code);
          // print(_course[code]['id']);
          courseItems.add(DropdownMenuItem(
              value: _course[code]['id'],
              child: Text(
                  _course[code]['titleTH'] + ' sec ' + _course[code]['sec'])));
        }
      });

      return qn.docs;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDAB94),
      body: Column(
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
                      'สถิติเข้าเรียนย้อนหลัง',
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
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              children: [
                const Text('ผลการเข้าเรียนย้อนหลัง',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFEDAB94),
                        fontWeight: FontWeight.normal)),
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
                  items: courseItems,
                  value: dropdownValue,
                  onChanged: (codeValue) {
                    if(mounted){
                    setState(() {
                      dropdownValue = codeValue;
                      if(dropdownValue=='start'){
                         isSelect = false;
                      }else
                      isSelect = true;

                      // dropdownValue = codeValue;

                      print(dropdownValue);
                      // subject = codeValue['titleTH'];
                    });};
                  },
                  isExpanded: false,
                ),
                const SizedBox(
                          height: 40,
                ),
                isSelect
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.61,
                            child: FutureBuilder<Widget>(
                                future: fetchStudennt(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: student.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          color: index % 2 == 0 ? const Color(0xFFFDF3ED) : Color(0xffEBE3DF),
                                          // color: Color.fromARGB(255, 255, 253, 237),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading:
                                                    Text('เลขที่ ${index + 1}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                        )),
                                                title: Text(
                                                  student[index]['stdId'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  student[index]['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              const ListTile(
                                                  leading: Text('เข้าเรียน xx',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                      )),
                                                  title: Text('ขาดเรียน xx',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                      ))),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          height: 20,
                                          thickness: 5,
                                          indent: 20,
                                          endIndent: 20,
                                          // color: Colors.black,
                                        );
                                      },
                                    );
                                  }

                                  return const Center(
                                      child: CircularProgressIndicator());
                                }),
                          ),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff98fb98)
                                    .withOpacity(0.9),
                                onPrimary: Color.fromARGB(255, 255, 255, 255),
                                // backgroundColor: Color(0xFFFDF3ED).withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: createExcel,
                              label: const Text(
                                "ดาวโหลดไฟล์ .xls",
                                style: TextStyle(fontSize: 20),
                              ), //label text
                              icon: Icon(Icons.download))
                        ],
                      )
                    : Text('โปรดเลือกรายวิชา')
              ],
            ),
          ))
        ],
      ),
    );
  }

  void createExcel() async {
    showAlertDialog(context);
    // var myList = [
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   },
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   },
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   },
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   },
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   },
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   },
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   },
    //   {
    //     "id": "116310400477-0",
    //     "name": "ปฐมาวดี ทับทอง",
    //     "count": "10"
    //   }
    // ];
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText("รหัสนักศึกษา");
    sheet.getRangeByIndex(1, 2).setText("ชื่อ-นามสกุล");
    sheet.getRangeByIndex(1, 3).setText("สถิติ");
    for (var i = 0; i < student.length; i++) {
      final item = student[i];
      sheet.getRangeByIndex(i + 2, 1).setText(item["stdId"].toString());
      sheet.getRangeByIndex(i + 2, 2).setText(item["name"].toString());
      sheet.getRangeByIndex(i + 2, 3).setText('test'.toString());
      // sheet.getRangeByIndex(i + 2, 3).setText(item["id"].toString());
    }
    final List<int> bytes = workbook.saveAsStream();
    // xcel.Workbook().dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '/storage/emulated/0/Download/static1.xlsx';
    final File file = File(fileName);
    print(path);
    await file.writeAsBytes(bytes, flush: true);
    Navigator.pop(context);

    // xcel.OpenFile.open(fileName);
  }
showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: Row(
            children: [
               const CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
            ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }
  // StreamBuilder<QuerySnapshot> newMethod(BuildContext context) {
  //   List<String> Items = [];
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: _firestoreInstance
  //           .collection('course')
  //           .doc(dropdownValue)
  //           .collection('students')
  //           .orderBy('no')
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           const CircularProgressIndicator();
  //         } else {
  //           final codeItem = snapshot.data?.docs.reversed.toList();
  //           Items.clear();
  //           for (var code in codeItem!) {
  //             Items.add(code['studentId'] + ' ' + code['name']);
  //             print(code['name']);
  //           }
  //         }
  //         return
  //             // Text('data');
  //             ListView.builder(
  //                 scrollDirection: Axis.vertical,
  //                 shrinkWrap: true,
  //                 itemCount: Items.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return Text(
  //                     Items[index] + index.toString(),
  //                   );
  //                 });
  //       });
  // }

  Future<Widget> fetchStudennt() async {
    QuerySnapshot qn = await _firestoreInstance
        .collection('course')
        .doc(dropdownValue)
        .collection('students')
        .orderBy('no')
        .get();
    if (mounted) {
      setState(() {
        student.clear();
        for (int i = 0; i < qn.docs.length; i++) {
          student.add({
            'id': qn.docs[i].id,
            "name": qn.docs[i]["name"],
            "stdId": qn.docs[i]['studentId'],
            'no': qn.docs[i]['no'],
            //.attendance': qn.docs[i]['attendance'].values
            //.reduce((sum, value) => sum + value),
          });
          // print(student);
        }
      });
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: student.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(
            student[index]['stdId'] + index.toString(),
          );
        });

    // Text('data');
  }
}
