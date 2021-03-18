

import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_channel_app/Model/MainM.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workmanager/workmanager.dart';

class MainVM {
  static const platform = const MethodChannel('flutterNativeText');
  static const platform_background = const MethodChannel('flutter_background');

  MainM maimM = MainM();

  CompositeSubscription compositeSubscription = CompositeSubscription();
  PublishSubject _nativeTextSubject = PublishSubject<String>();

  //Observable<String> get setTextNative=>_nativeTextSubject.stream;
  Stream get streamText => _nativeTextSubject.stream;

  //для кнопки запуска фонового режима на котлин
  PublishSubject backgroundSubject = PublishSubject<String>();
  Stream get backgroundSubjectStream => backgroundSubject.stream;


  void startListen() {
    //WidgetsFlutterBinding.ensureInitialized();


    platform.setMethodCallHandler(nativeMethodHadler);
    platform_background.setMethodCallHandler(nativeMethodHadlerBackground);
    _nativeTextSubject.stream.listen((event) {
      print("**simpleClickText stream!");
      return event;
    });
    //для кнопки запуска фонового режима на котлин слушаю события и отображения в вью
    backgroundSubject.stream.listen((event) {
      print("**backgroundSubject");
      return event;
    }
    );
    // initWorkManagerAsync();
  }

  // void initWorkManagerAsync() {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   Workmanager.initialize(callbackDispatcher);
  //   // Workmanager.registerPeriodicTask(
  //   //   "3",
  //   //   "simplePeriodicTask",
  //   //   //initialDelay: Duration(seconds: 2),
  //   //   frequency: Duration(minutes: 15)
  //   // );
  // }

  void dispose() {
    compositeSubscription.dispose();
  }


  Future<void> simpleClickText() async {//по нажатию на кнопку вызывает метод в андроиде
    //  try {
    final String result = await platform.invokeMethod('getSimpleNativeText');//в этой строке и вызывает
    print("**simpleClickText sink!");
    _nativeTextSubject.sink.add("**async text is $result");


    Workmanager.registerPeriodicTask(
        "1",
        "simplePeriodicTask",
        //initialDelay: Duration(seconds: 2),
        frequency: Duration(minutes: 15)
    );

  }


  Future<void> simpleClickTextPeriodicBackground() async {//вызывается в фоне периодически
    //  try {
    final String result = await platform_background.invokeMethod('getSimpleNativeTextPeriodic');//в этой строке и вызывает
    print("**PERIODIC native called from flutter!");


  }

  Future<dynamic> nativeMethodHadler (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getText'://channel.invokeMethod в kotlin вызывает методы из списка опционально
        print("**getText native in flutter! ${methodCall.arguments}");
        return "**native text called!";

      default:
        throw MissingPluginException('notImplemented');
    }
  }


  /// for background processes

  Future<dynamic> nativeMethodHadlerBackground (MethodCall methodCall) async {
    switch (methodCall.method) {

      case 'periodic_string_background':

        print("**PERIODIC periodic_string_background native in flutter! ${methodCall.arguments}");
     //   _nativeTextSubject.sink.add("**PERIODIC async text is ${methodCall.arguments}");
        return "**periodic_string_background called! ";

      case 'stopBackgroundAndShow'://фоновый процесс в котлин остановлен
      print("**PeriodicBackground stopped in flutter and show result");
      _nativeTextSubject.sink.add("**PERIODIC async text is ${methodCall.arguments}");
      return "**periodic has stopped!";


      default:
        throw MissingPluginException('notImplemented');
    }
  }

  /// for background process in kotlin

 Future<dynamic> getNativeDataFromBackground(){

    //TODO 1)остановить/запустить фоновый процесс
   startOrStopBackgroundProcessNative();
    // TODO 2) получить данные наработанные в фоне
    getDataBackground();
    // TODO 3) отобразить/распечатать их
    showData();
  }

  //1)
  String startOrStopBackgroundProcessNative(){
     periodicBackground();

  }

  //2)
  String getDataBackground(){

  }

  //3)
  void showData(){

  }

  //вызывает старт/финиш фоновой операции в нативном коде
  Future<dynamic> periodicBackground() async {
    //  try {
    final String result = await platform_background.invokeMethod('startOrStopBackground');//в этой строке и вызывает
    print("**PERIODIC_KOTLIN called from flutter! ");
  }

}