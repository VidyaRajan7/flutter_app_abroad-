import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class FlutterToNativeHome extends StatefulWidget {
  FlutterToNativeHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FlutterToNativeHomeState createState() => _FlutterToNativeHomeState();
}

class _FlutterToNativeHomeState extends State<FlutterToNativeHome> {

  static const platform = const MethodChannel('flutter.native/helper');
  String _responseFromNativeCode = 'Waiting for Response...';
  String _responseFromScreenRecorder = 'Waiting for Recording.....';
  bool recordingStarted = false;
  bool isMute = false;

  Future<void> responseFromNativeCode() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('helloFromNativeCode');
      response = result;
    } on PlatformException catch(e) {
      response = "Failed to Invoke: '${e.message}'.";
    }

    setState(() {
      _responseFromNativeCode = response;
    });
  }

  Future<void> responseFromScreenRecorder() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('screenRecordingFromNative');
      response = result;
      if(response == 'Recording...') {
        recordingStarted = true;
      } else {
        recordingStarted = false;
      }
    } on PlatformException catch(e) {
      recordingStarted = false;
      response = "Failed to Invoke: '${e.message}'.";
    }

    setState(() {
      _responseFromScreenRecorder = response;
    });
  }

  Future<void> responseFromNativeMute() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('muteOrUnMuteFromNative');
      response = result;
      if(response == 'Mute') {
        isMute = true;
      } else {
        isMute = false;
      }
    } on PlatformException catch(e) {
      response = "Failed to Invoke: '${e.message}'.'";
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green,
      title: Text('ScreenRecording'),
      actions: <Widget>[
        FlatButton.icon(
            onPressed: responseFromNativeMute,
            icon: Icon(isMute ? Icons.mic_off : Icons.mic),
            label: Text(isMute ? 'Mute' : 'UnMute')
        ),
        IconButton(
          icon: Icon(recordingStarted ? Icons.pause : Icons.play_arrow),
          tooltip: 'Start Recording',
          onPressed: responseFromScreenRecorder,
        ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text('Call Native Mathod'),
            onPressed: responseFromNativeCode,
          ),
          Text(_responseFromNativeCode),
          Text(_responseFromScreenRecorder),
        ],
      ),
    ),
  );
  }
}