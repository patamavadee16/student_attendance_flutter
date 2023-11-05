import 'package:flutter/material.dart';
class staticPage extends StatefulWidget {
  const staticPage({super.key});

  @override
  State<staticPage> createState() => _staticPageState();
}

class _staticPageState extends State<staticPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEDAB94),
        
        title: const Row(
          children: [
            Icon(Icons.stacked_line_chart,size: 40,color: Colors.brown,),
            SizedBox(width: 10,),
            Text("สถิติ",style: TextStyle(color: Colors.brown),),
          ],
        ),
      ),
      body: Container(),
    );
  }
}