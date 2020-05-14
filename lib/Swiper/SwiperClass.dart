import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

import 'package:flutter_swiper/flutter_swiper.dart';


import 'package:flutter/cupertino.dart';
final List<String> images = [
  "https://thumbs.dreamstime.com/b/two-birds-perched-twig-orange-cheeked-waxbill-34508046.jpg",
  "https://thumbs.dreamstime.com/b/two-birds-perched-twig-orange-cheeked-waxbill-34508046.jpg",
  "https://thumbs.dreamstime.com/b/two-birds-perched-twig-orange-cheeked-waxbill-34508046.jpg"
];


class SwiperClass extends StatefulWidget {
  SwiperClass({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SwiperSateClass createState() => new _SwiperSateClass();
}

class _SwiperSateClass extends State<SwiperClass> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Swiper Example"),
      ),
      body:  new Swiper(
        itemBuilder: (BuildContext context,int index){
          print("swiper");
          if(index == 0) {
            return new Container(
              color: Colors.blue,
            );
          } else if(index == 1) {
            return new Container(
              color: Colors.green,
            );
          } else {
            return new Container(
              color: Colors.red,
            );
          }

        },
        autoplay: false,
        itemCount: images.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
}