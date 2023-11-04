import 'package:flutter/material.dart';

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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                   const Text('F A C E'),
                   const Text("Recognition Attendance"),
                   const Text('Mobile Application'),
                  SizedBox(
                    height: 100, 
                    width: 300, 
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
                      )
                    ),
                  )
                ])
              )
            ),
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
              onPressed: () { },
              child: const Text('Check'),
              )
            ),
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
              onPressed: () { },
              child: const Text('Static'),
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