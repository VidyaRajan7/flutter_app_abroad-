import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:painter2/painter2.dart';
import 'dart:typed_data';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'TextEditorClass.dart';
import 'TextViewclass.dart';
import 'package:signature/signature.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

//save img to gallery
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


List fontsize = [];
var slider = 0.0;
SignatureController _scontroller =
SignatureController(penStrokeWidth: 5, penColor: Colors.green);
var width = 300;
var height = 300;
var newIndex =0;
var imageIndex = 0;
String tempImgName;
bool isLoading = false;
 List images = [
  "https://thumbs.dreamstime.com/b/two-birds-perched-twig-orange-cheeked-waxbill-34508046.jpg",
  "https://images.pexels.com/photos/56866/garden-rose-red-pink-56866.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
  "https://www.petsworld.in/blog/wp-content/uploads/2014/09/cute-kittens.jpg",
   "https://media.gettyimages.com/photos/idyllic-home-with-covered-porch-picture-id479767332?s=612x612"
];



class PainterClass extends StatefulWidget{
  @override
  _PainterClassState createState() => _PainterClassState();
}

class _PainterClassState extends State<PainterClass> {
  bool _finished;
  PainterController controller;
  List type = [];
  List multiwidget = [];
  List<Offset> offsets = [];
  final scaf = GlobalKey<ScaffoldState>();
  List<Offset> _points = <Offset>[];

  bool needNewPainter = true;
  bool hasInitializedSwiper = false;

//Test
  GlobalKey _globalKey = new GlobalKey();
//Uint8List imageInMemory;
  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 10.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final file = await _localFile;
      file.writeAsBytes(pngBytes);
//      // Save img to Gallery
//      final res = await ImageGallerySaver.saveImage(pngBytes);
//      //Upto here Save img to gallery
//    setState(() {
//      imageInMemory = pngBytes;
//    });
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }
//Upto here Test

  Future<Uint8List> readContent() async {
    //try {
    final file = await _localFile;
    // Read the file
    Uint8List bytes;
    await file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError) {
      onError.toString();
    });
    return bytes;
  }

  Future deleteImgFile() async {
    final file = await _localFile;
    file.delete();
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    String fileName = images[imageIndex];
    final replaced = fileName.replaceAll("/", "-");
    return File('$path/$replaced');

  }



  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  @override
  void initState() {
    super.initState();
    _finished = false;
    multiwidget.clear();
    controller = newController();

  }

  PainterController newController() {

    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.green;
    readContent().then((imgFile) {
      if(imgFile != null) {
        controller.backgroundImage = Image.memory(imgFile,
        fit: BoxFit.cover,);
      } else {
        controller.backgroundImage = Image.network(
          images[imageIndex],
          fit: BoxFit.cover,
        );

      }

    });

    return controller;
  }









  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            multiwidget.clear();
           controller = newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: () {

            if (controller.canUndo)
              {
                controller.undo();
              } else {
               if (multiwidget != null) {
                 multiwidget.removeLast();
                 type.add(2);
                 setState(() {
                   multiwidget = multiwidget;
                 });
                // actions.removeLast();
               }
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.redo),
          tooltip: 'Redo',
          onPressed: () {
            if (controller.canRedo) controller.redo();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: () => setState(() {
            deleteImgFile();
            multiwidget.clear();
            controller.clear();
          })
        ),
        IconButton(
          icon: Icon(Icons.text_fields),
          onPressed: () async {
            final value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TextEditor()));
            if ((value.toString().isEmpty) || (value == null)) {
            } else {
              type.add(2);
              fontsize.add(20);
              offsets.add(Offset.zero);
              multiwidget.add(value);
              setState(() {
                isLoading = true;
              });
              Timer(Duration(seconds: 2), () {
                _capturePng().then((value) {
                  setState(() {
                    isLoading = false;
                  });
                });
              });
            }
          },tooltip: "Text",
        ),
        IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              setState(() {
                _finished = true;
              });
            //Timer(Duration(seconds: 3), () {
              _capturePng().then((imgData) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return Scaffold(
                      appBar: AppBar(
                        title: Text('View your image'),
                      ),
                      body: SingleChildScrollView(
                        child: Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              imgData != null ? Container(
                                child: Image.memory(imgData),
                                margin: EdgeInsets.all(10),
                              ) : Container(),
                            ],
                          ),
                        ),
                      )
                  );
                }));
              });
            //});




            }),
      ];
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Painter2 Example'),
          actions: actions,
          bottom: PreferredSize(
            child: DrawBar(controller),
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
          )),
        body: RepaintBoundary(
          key: _globalKey,
          child: Stack(
            children: <Widget>[
              Container(
                child: Center(
                  //child: getSwiper(),
                    child: AspectRatio(aspectRatio: 1.0, child: Painter(controller))
                ),
              ),
              Center(
                child: (Container(
                  width: 24,
                  height: 24,
                  child: (isLoading ? CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ) : Container()),
                  )),
                ),

              Stack(
                children: multiwidget.asMap().entries.map((f) {
                  return type[f.key] == 1
                      ? Container()
                      : type[f.key] == 2
                      ? TextView(
                    left: offsets[f.key].dx,
                    top: offsets[f.key].dy,
                    ontap: () {
                      scaf.currentState
                          .showBottomSheet((context) {
                        return Sliders(
                          size: f.key,
                          sizevalue:
                          fontsize[f.key].toDouble(),
                        );
                      });
                    },
                    onpanupdate: (details) {
                      setState(() {
                        offsets[f.key] = Offset(
                            offsets[f.key].dx +
                                details.delta.dx,
                            offsets[f.key].dy +
                                details.delta.dy);
                      });
                    },
                    value: f.value.toString(),
                    fontsize: fontsize[f.key].toDouble(),
                    align: TextAlign.center,
                  )
                      : new Container();
                }).toList(),
              )
            ],
          ),
        )
      );
  }


  getSwiper() {
    return Center(
//      child: ListView.builder(
//        scrollDirection: Axis.horizontal,
//        itemCount: images.length,
//        itemBuilder: (context, index){
//          //if(needNewPainter == true) {
//            imageIndex = index;
//            PainterController con = new PainterController();
//            con.thickness = 5.0;
//            con.backgroundColor = Colors.green;
//            _controller = newController();
//            _controller = con;
//            con.backgroundImage = Image.network(
//              images[index],
//              fit: BoxFit.contain,
//            );
//            return Center(
//              child: AspectRatio(aspectRatio: 1.0, child: Painter(con),),
////            child: Image.network(
////              images[index],
////                  fit: BoxFit.contain,
////            ),
//            );
//         //}
////          else {
////            return Center(
////              child: AspectRatio(aspectRatio: 1.0, child: Painter(_controller),),
////            );
////
////          }
//        return Center();
//        },
//
//      ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            if( imageIndex != index) {
              imageIndex = index;
              PainterController cont = newController();
              return new AspectRatio(aspectRatio: 1.0,
                child: Painter(cont),
              );
            }
            return new AspectRatio(aspectRatio: 1.0,
              child: Painter(controller),
            );
          },

          autoplay: false,
          itemCount: images.length,
         //s pagination: new SwiperPagination(),
          //control: new SwiperControl(),
        ),
    );

  }

}



class DrawBar extends StatelessWidget {
  final PainterController controller;

  DrawBar(this.controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  child: Slider(
                    value: controller.thickness,
                    onChanged: (value) => setState(() {
                      controller.thickness = value;
                    }),
                    min: 1.0,
                    max: 20.0,
                    activeColor: Colors.white,
                  ));
            })),
        ColorPickerButton(controller, false),
        ColorPickerButton(controller, true),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController controller;
  final bool _background;

  ColorPickerButton(this.controller, this._background);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_iconData, color: _color),
      tooltip:
      widget._background ? 'Change background color' : 'Change draw color',
      onPressed: () => _pickColor(),
    );
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Pick color'),
              ),
              body: Container(
                  alignment: Alignment.center,
                  child: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (Color c) => pickerColor = c,
                  )));
        }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget.controller.backgroundColor
      : widget.controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget.controller.backgroundColor = color;
    } else {
      widget.controller.drawColor = color;
    }
  }
}

class Sliders extends StatefulWidget {
  final int size;
  final sizevalue;
  const Sliders({Key key, this.size, this.sizevalue}) : super(key: key);
  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizevalue;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Text("Slider Size"),
            ),
            Divider(
              height: 1,
            ),
            new Slider(
                value: slider,
                min: 0.0,
                max: 100.0,
                onChangeEnd: (v) {
                  setState(() {
                    fontsize[widget.size] = v.toInt();
                  });
                },
                onChanged: (v) {
                  setState(() {
                    slider = v;
                    fontsize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}

class PainterSwiperClass extends StatefulWidget{
  @override
  _PainterSwiperState createState() => _PainterSwiperState();
}

class _PainterSwiperState extends State<PainterSwiperClass> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          imageIndex = index;
         // PainterClass().method();

          //Timer(Duration(seconds: 3), () {
            return PainterClass();
         // });
        },
          itemCount: images.length
        ),
    );
  }
}



