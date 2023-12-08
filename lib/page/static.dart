import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';

class staticPage extends StatefulWidget {
  const staticPage({super.key});

  @override
  State<staticPage> createState() => _staticPageState();
}

class _staticPageState extends State<staticPage> {
  String dropdownValue = '0';
  final List _course = [];
  bool isSelect = false;
  List<DropdownMenuItem> courseItems = [];
  final _firestoreInstance = FirebaseFirestore.instance;
  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance
        .collection('course')
        .where('teacher', isEqualTo: 'อาจารย์.ดร.พิชยพัชยา ศรีคร้าม')
        .get();
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

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
   

      Column(
        children: [
            Container(
            padding: EdgeInsets.only(top: 25),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: DecoratedBox(
                  decoration: BoxDecoration(
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
                          child: Column(
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
          Container(
            child: SizedBox(
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
          ),DropdownButtonFormField(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
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
                            setState(() {
                              dropdownValue=codeValue;
                              isSelect=true;
                              // dropdownValue = codeValue;

                              // print(dropdownValue);
                              // subject = codeValue['titleTH'];
                            });
                          },
                          isExpanded: false,
                        ),
          isSelect? SizedBox(
            height: 600,
            child: newMethod(context)):Text('data')
        ],
      ),
 
  );

    
  }

  StreamBuilder<QuerySnapshot> newMethod(BuildContext context) {
    List<String> Items = [];
    return StreamBuilder<QuerySnapshot>(
      
        stream: _firestoreInstance
            .collection('course')
            .doc(dropdownValue)
            .collection('students').orderBy('studentId')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            const CircularProgressIndicator();
          } else {
            final codeItem = snapshot.data?.docs.reversed.toList();
            for (var code in codeItem!) {
              Items.add(code['name']);
              print(code['name']);
            }
          }
          return
              // Text('data');
 ListView.builder(
                    scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                          itemCount: Items.length,
                          itemBuilder: (BuildContext context, int index) {
                return Text(
                 Items[index]+index.toString(),
                );
                          
              
        });});
  

}}
