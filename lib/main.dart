import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_native_channel_app/ViewModel/MainVM.dart';
import 'package:workmanager/workmanager.dart';


// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) {
//     print("**Native called background task: "); //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }
MainVM vm ;


void callbackDispatcher() {

  Workmanager.executeTask((task, inputData)  {
    switch(task){
      case "simplePeriodicTask":
        print("**PERIODIC Native called periodic background task ");
        vm.simpleClickTextPeriodicBackground();
        //simpleClickTextPeriodicBackground();
        break;
      default:
        print("**periodic default!");
        break;
    }


    // getLocation();
    return Future.value(true);
  });
}

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // Workmanager.initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  // );
  // Workmanager.registerPeriodicTask("1", "simpleTask",frequency:Duration(seconds: 3));

  vm = MainVM();

  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher);


  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // title: 'Flutter Native Demo',

      home: MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget{

  // MainVM vm = MainVM();


  @override
  _MainScreenState createState() => _MainScreenState();
}





class _MainScreenState extends State<MainScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vm.startListen();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    vm.dispose();
  }


  @override
  Widget build(BuildContext context) {


    //int counternativeClick =0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Native Chanel Example"),
      ),
      body: Column(
      children: [
        StreamBuilder(
            stream: vm.streamText,
            builder: (context, snapshot) {
              print("**snapshot data ${snapshot.data}");
             // counternativeClick++;
              return Text("snapshot.data ${snapshot.data}"??"native text must be here");
            }),

        FlatButton(
            onPressed: (){
            //  counternativeClick++;
              vm.simpleClickText();
              },
            child: Container(
            child: Text("tap to get NativeText!"),
            color: Colors.green,
        )
        ),

        Text("TODO foreground text"),
        FlatButton(onPressed: (){//кнопка для старта фонового процесса и его остановки/получения данных

          vm.getNativeDataFromBackground();

        }, child: Text("press to start background process in kotlin"))
      ],
    ));
    throw UnimplementedError();
  }
}

