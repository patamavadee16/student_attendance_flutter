import 'package:flutter/material.dart';
import 'package:student_attendance/page/home.dart';
import 'package:student_attendance/page/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 112, 112)),
        // useMaterial3: true,
      ),
      // home:const login()
      home: const Home()
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // title: Text(widget.title),
//       ),
//       body:
//        Center(
//         child: Column(
          
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           // crossAxisAlignment: ,
//           children: <Widget>[
//             SizedBox(
//               // color: Colors.blueAccent ,
//               height: 300.0, 
//               width: 350, 
//               child: DecoratedBox(
//                 decoration: BoxDecoration(  
//                   color:Color(0xFFEDAB94) 
//                   ,borderRadius: BorderRadius.circular(40.0), 
//                   )
//               )
//             ),
//             SizedBox(
//               // color: Colors.blueAccent ,
//               height: 130, 
//               width: 350, 
//               child: DecoratedBox(
//                 decoration: BoxDecoration(  
//                   color:const Color(0xFFFDF3ED) 
//                   ,borderRadius: BorderRadius.circular(25.0), 
//                    boxShadow: const [ 
//                     BoxShadow( 
//                       color: Colors.grey , 
//                       blurRadius: 2.0, 
//                       offset: Offset(2.0,2.0) 
//                     ) 
//                   ] 
//                   )
//               )
//             ),
//               SizedBox(
         
//               height: 130, 
//               width: 350, 
//               child:  ElevatedButton(
//               style:  ElevatedButton.styleFrom(
//               backgroundColor:const Color(0xFFFDF3ED),
//               elevation: 10,
//               shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25.0),
//                   ),
//               shadowColor: Colors.grey ,
              
              
              
//               ),
//               onPressed: () { },
//               child: Text('Static'),
//               )
//               // DecoratedBox(
//               //   decoration: BoxDecoration(  
//               //     color:const Color(0xFFFDF3ED) 
//               //     ,borderRadius: BorderRadius.circular(25.0), 
//               //     boxShadow: const [ 
//               //       BoxShadow( 
//               //         color: Colors.grey , 
//               //         blurRadius: 2.0, 
//               //         offset: Offset(2.0,2.0) 
//               //       ) 
//               //     ] 
//               //     )
//               // )
//             ),
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: (){},
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
