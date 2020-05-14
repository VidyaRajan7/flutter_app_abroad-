import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class TextSwiper extends StatefulWidget {
  TextSwiper({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TextSwiperState createState() => _TextSwiperState();
}

class _TextSwiperState extends State<TextSwiper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TextSwiper"),
      ),
      body: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: 300.0,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              Center(
                child: Image.network(
                  "https://www.petsworld.in/blog/wp-content/uploads/2014/09/cute-kittens.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Container(
                  //width: 90,
                  //height: 90,
                  //color: Colors.white,
                  child: Text("Your Text here No: ${index}",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              )
            ],
          );
        },
        itemCount: 3,
        pagination: SwiperPagination(),
        control: SwiperControl(),
      ),
    );
  }
}