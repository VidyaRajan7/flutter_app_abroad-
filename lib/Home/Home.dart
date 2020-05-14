
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:painter2/painter2.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: getFormWidget()
        //Stack(
      )
    );

//    return Scaffold(
//      body: ListView(
//        //Stack(
//        children: <Widget>[
//          Center(
//            child: ListView(
//              children: <Widget>[
//                Container(
//                  height: ((MediaQuery.of(context).size.height) / 100 * 25),
//                  child: Image.asset("assets/images/google_map.png"),
//                ),
//                Container(
//                  height: 40,
//                  width: 40,
//                  color: Colors.red,
//                )
//              ],
//            ),
//          ),
//          new Positioned(
//            right: 20,
//              top: 40,
//              child: Container(
//                child: getSideMenuWidget(),
//              )
//          ),
//          new Positioned(
//            top: ((MediaQuery.of(context).size.height) / 100 * 25) - 58,
//              left: 20,
//              child: Container(
//                decoration: BoxDecoration (
//                  color: Colors.white,
//                  border: Border.all(
//                    color: Colors.grey,
//                    width: 1.5,
//                  ),
//                  borderRadius: BorderRadius.circular(10.0),
//                ),
//                height: 38,
//                width: (MediaQuery.of(context).size.width - 50),
//                child: SizedBox(
//                  width: (MediaQuery.of(context).size.width - 50),
//                  height: 38,
//                  child:  Center(child: TextFormField(
//                    controller: _filter,
//                    decoration: InputDecoration(
//                        fillColor: Colors.white,
//                        filled: true,
//                        hintText: 'SEARCH',
//                        icon: Icon(Icons.search)
//                    ),
//                  ),
//                  ),
//                )
//          )
//          ),
//          new Positioned(
//            top: ((MediaQuery.of(context).size.height) / 100 * 25),
//              height: (MediaQuery.of(context).size.height) -((MediaQuery.of(context).size.height) / 100 * 25),
//              width: (MediaQuery.of(context).size.width),
//              child: getListItemWidget()
//          )
//        ],
//      ),
//    );
  }

  Widget getSideMenuWidget() {
    return Center(
      child: SizedBox(
        width: 28,
        height: 30,
        child: RaisedButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
          },
          child: new Row(
            children: <Widget>[
              new Image.asset("assets/images/gray_hamburger.png"),
            ],
          ),
        ),
        //child: Image.asset("assets/images/gray_hamburger.png"),
      ),
    );
  }

  Widget getListItemWidget() {
    return Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('United States'),
          ),
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('India'),
          ),
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('Germany'),
          )
        ],
      ),
    );
  }

  Widget getSearchBarWidget() {
    return Center(child: TextFormField(
      controller: _filter,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'SEARCH',
          icon: Icon(Icons.search)
      ),
    ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    Column c1 = Column(
      children: <Widget>[
        Center(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: ((MediaQuery.of(context).size.height) / 100 * 25),
                  width: (MediaQuery.of(context).size.width),
                  child: Image.asset("assets/images/google_map.png"),
                ),
              ),
              new Positioned(
                  right: 20,
                  top: 20,
                  child: Container(
                    child: getSideMenuWidget(),
                  )
              ),
              new Positioned(
                  top: ((MediaQuery.of(context).size.height) / 100 * 25) - 58,
                  left: 20,
                  child: Container(
                      decoration: BoxDecoration (
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 38,
                      width: (MediaQuery.of(context).size.width - 50),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width - 50),
                        height: 38,
                        child:  getSearchBarWidget()
                      )
                  )
              ),
            ],
          )
        )
      ],
    );
    formWidget.add(c1);

    formWidget.add(Container(
      height:  ((MediaQuery.of(context).size.height) - ((MediaQuery.of(context).size.height) / 100 * 25)),
      color: const Color(0xff2980b9),
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: getListItemWidget()
      )
    );
    return formWidget;
  }

}