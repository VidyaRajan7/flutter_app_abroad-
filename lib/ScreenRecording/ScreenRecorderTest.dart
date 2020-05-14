import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:quiver/async.dart';
import 'package:flutter/services.dart';

class ScreenRecordingTest extends StatefulWidget {
  @override
  _ScreenRecordingTestState createState() => _ScreenRecordingTestState();
}

class _ScreenRecordingTestState extends State<ScreenRecordingTest> {
  String textBtn = "Play";
  bool recording = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Running'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Text('$textBtn'),
          onPressed: () async {
            if (recording) {
              stopScreenRecord();
            } else {
              startScreenRecord();
            }
          },
        ),
      ),
    );
  }

  startScreenRecord() async {
    final result = await FlutterScreenRecording.startRecordScreen("Title");
    print(result);
    if(result){
      textBtn = "Stop";
      recording = true;
      print("Start");
    }
  }

  stopScreenRecord()  async {
    recording = false;
    final result = await FlutterScreenRecording.stopRecordScreen;
    textBtn = result;
    print(result);
  }
}