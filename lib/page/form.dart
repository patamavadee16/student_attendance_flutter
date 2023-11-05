import 'package:flutter/material.dart';

class form extends StatefulWidget {
  const form({super.key});

  @override
  State<form> createState() => _formState();
}

class _formState extends State<form> {
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
      body: 
      
      Container(),
    );
  }
}