
import 'package:flutter/material.dart';
import 'package:flutterappabroad/LiberateHealthApp/LiberateHome.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget{

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    // TODO: implement build
    return null;
  }
}

class LoginPage extends StatefulWidget{
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailText = TextEditingController();
  TextEditingController pwdText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("liberate health", style: TextStyle(fontSize: 30, color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              shrinkWrap:  true,
              children: getFormWidget()
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget emailTextFiled() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.0),
              color: Colors.white,
            border: Border.all(
            color: Colors.grey
        )
        ),
        child: SizedBox(
          width: (MediaQuery.of(this.context).size.width / 2),
          height: 50,
          child: TextFormField(
            controller: emailText,
            style:  TextStyle(
                fontSize: 20
            ),
            decoration: InputDecoration(
                hintText: 'Enter your Email'
            ),
          ),
        ),
      ),
    );
  }

  Widget pwdTextFiled() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.0),
            border: Border.all(
                color: Colors.grey
            )
        ),
        child: SizedBox(
          width: (MediaQuery.of(this.context).size.width/2),
          height: 50,
          child: TextFormField(
            controller: pwdText,
            style:  TextStyle(
              fontSize: 20
            ),
            decoration: InputDecoration(
                hintText: 'Password'
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = List();
    Column c1 = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: SizedBox(
                  height: (50 ),
                  width: (MediaQuery.of(this.context).size.width),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: (MediaQuery.of(this.context).size.width),
                      child: emailTextFiled(),
                    ),
                  ),
                )
            )
          ],
        )

      ],
    );
    formWidget.add(c1);

    formWidget.add(
      Container(
        margin: EdgeInsets.only(bottom: 0),
        child: Center(
          child: SizedBox(

            width: (MediaQuery.of(this.context).size.width),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      child: new Container(
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        color: Colors.white,
                        height: 50,
                        child: pwdTextFiled(),
                      ),
                    ),
                  ],
                ),
            )
          ),
        ),
      );


//
//    formWidget.add(
//      Container(
//        margin: EdgeInsets.only(top: 0),
//        child: Container(
//          margin: new EdgeInsets.symmetric(vertical: 0, horizontal: 105.0),
//          child: Center(
//            child: SizedBox(
//              width: MediaQuery.of(context).size.width,
//              height: 50,
//              child: Padding(
//                padding: EdgeInsets.only(left: 100.0, right: 100.0),
//                child: RaisedButton(
//                  textColor: Colors.white,
//                  color: Colors.red,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text('Sign in', style: TextStyle (
//                           fontSize: 25
//                          ),),
//                        ),
//                      )
//                    ],
//                  ),
//                  onPressed: () {
//
//                  },
//                ),
//              ),
//            ),
//          ),
//        ),
//      )
//    );

    formWidget.add(
      SafeArea(
        child: Center(
          child: Container(
            color: Colors.redAccent,
            width: (MediaQuery.of(this.context).size.width / 2),
            height: 50,
            child: RaisedButton(
              textColor: Colors.white,
              splashColor: Colors.grey,
              child: Text('Sign In', style: TextStyle(
                fontSize: 22
              ),),
              color: Colors.red,
              onPressed: () async {
                Navigator.push(
                    this.context,
                    MaterialPageRoute(
                        builder: (context) => LiberateHome()));
              },
            ),
          ),
        ),
      )
    );


    return formWidget;
  }



}

