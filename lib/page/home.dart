import 'package:flutter/material.dart';
import 'package:student_attendance/page/form.dart';
import 'package:student_attendance/page/static.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   // title: Text(widget.title),
      // ),
      body:
       Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            SizedBox(
              height: 300.0, 
              width: 350, 
              child: DecoratedBox(
                decoration: BoxDecoration(  
                  color:const Color(0xFFEDAB94) 
                  ,borderRadius: BorderRadius.circular(40.0), 
                  ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 20),
                    const Text('F A C E',style: TextStyle(fontSize: 20,color: Colors.white),),
                    const SizedBox(height: 10),
                    const Text("Recognition Attendance",style: TextStyle(fontSize: 20,color: Colors.white)),
                    const SizedBox(height: 10),
                    const Text('Mobile Application',style: TextStyle(fontSize: 20,color: Colors.white)),
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 50,
                      width: 300, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.computer,color: Color.fromARGB(255, 88, 88, 88),),
                          Icon( Icons.face ,color: Color.fromARGB(255, 88, 88, 88),),
                          Icon( Icons.image,color: Color.fromARGB(255, 88, 88, 88),),
                          Icon( Icons.photo_camera,color: Color.fromARGB(255, 88, 88, 88),),
                          Icon( Icons.checklist,color:Color.fromARGB(255, 88, 88, 88), ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      
                      height: 100, 
                      width: 300, 
                      child: Container(
                        child: DecoratedBox(
                      
                          decoration: BoxDecoration(  
                            color: const Color(0xFFFDF3ED) ,
                            borderRadius: BorderRadius.circular(25.0), 
                            boxShadow: const [ 
                              BoxShadow( 
                                color: Colors.grey , 
                                blurRadius: 2.0, 
                                offset: Offset(2.0,2.0) 
                              ) 
                            ] 
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text('ผู้สอน : ')),
                          
                        ),
                      ),
                    )
                ])
              )
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 130, 
              width: 350, 
              child: ElevatedButton(
              style:  ElevatedButton.styleFrom(
                primary:const Color(0xFFFDF3ED),
                onPrimary: const Color(0xFFEDAB94),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                shadowColor: Colors.grey ,
              ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const form()),
                );
               },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration:const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7DBAE7),
                      ),
                      child: const Icon(Icons.library_add_check, size: 55,color: Colors.white,),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: const Text(
                              'Attendance',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20,),
                              ),
                          ),
                          Text(
                            'เช็คชื่อ',style: TextStyle(color: Colors.grey[500],fontSize: 20,),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              )
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 130, 
              width: 350, 
              child:  ElevatedButton(
              style:  ElevatedButton.styleFrom(
                primary:const Color(0xFFFDF3ED),
                onPrimary: const Color(0xFFEDAB94),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                shadowColor: Colors.grey ,
              ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const staticPage()),
                );
               },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                     Container(
                      width: 75,
                      height: 75,
                      decoration:const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7DBAE7),
                      ),
                      child: const Icon(Icons.addchart, size: 55,color: Colors.white,),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: const Text(
                              'Statistics',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20,),
                              ),
                          ),
                          Text(
                            'สถิติ',style: TextStyle(color: Colors.grey[500],fontSize: 20,),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              )
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}