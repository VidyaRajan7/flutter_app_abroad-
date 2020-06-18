import 'package:flutter/material.dart';


class MasterDetailPage extends StatefulWidget{
  _MasterDetailPageState createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  var selectedValue = 0;
  var isLargeScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MultipleScreenSupport"),
      ),
      body: OrientationBuilder(builder: (context, orietation) {
        if(MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }

        return Row(
          children: <Widget>[
            Expanded(
              child: ListWidget(10, (value){
                if(isLargeScreen) {
                  selectedValue = value;
                  setState(() {});
                } else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return DetailPage(value);
                    },
                  ));
                }

              }),
            ),
            isLargeScreen ? Expanded(child: DetailWidget(selectedValue)) : Container(),
          ]
        );
      },),
    );
  }
}


typedef Null ItemSelectedCallback(int value);

class ListWidget extends StatefulWidget {
  final int count;
  final ItemSelectedCallback onItemSelected;

  ListWidget(this.count, this.onItemSelected);
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.count,
        itemBuilder: (context, position) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: InkWell(
              onTap: () {
                widget.onItemSelected(position);
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(position.toString(), style: TextStyle(fontSize: 22.0),),
                  )
                ],
              ),
            ),
          ),
        );
        }
    );
  }
}

class DetailPage extends StatefulWidget{
  final int data;
  DetailPage(this.data);
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: DetailWidget(widget.data),
    );
  }
}

class DetailWidget extends StatefulWidget{

  final int data;
  DetailWidget(this.data);

  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.data.toString(), style: TextStyle(fontSize: 36.0, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}