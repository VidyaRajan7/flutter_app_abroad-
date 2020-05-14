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

class PainterClassTemp extends StatefulWidget{
  @override
  _PainterClassTempState createState() => _PainterClassTempState();
}

class _PainterClassTempState extends State<PainterClassTemp> {
  bool _finished;
  PainterController _controller;
  List type = [];
  List multiwidget = [];
  List<Offset> offsets = [];
  final scaf = GlobalKey<ScaffoldState>();
  List<Offset> _points = <Offset>[];
  var imageIndex = 0;
  final List<String> images = [
    "https://thumbs.dreamstime.com/b/two-birds-perched-twig-orange-cheeked-waxbill-34508046.jpg",
    "https://images.pexels.com/photos/56866/garden-rose-red-pink-56866.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
    "https://www.petsworld.in/blog/wp-content/uploads/2014/09/cute-kittens.jpg"
  ];

  @override
  void initState() {
    super.initState();
    _finished = false;
    multiwidget.clear();
    _controller = newController();
  }

  PainterController newController() {
    print("After");

    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.green;

    controller.backgroundImage = Image.network(
        images[imageIndex]
    );
    print(imageIndex);
    //'https://thumbs.dreamstime.com/b/two-birds-perched-twig-orange-cheeked-waxbill-34508046.jpg');
    return controller;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

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
    // ByteData contents = await file.readAsBytes()
    // Returning the contents of the file

    return bytes;
  }



//Test
  GlobalKey _globalKey = new GlobalKey();
  bool inside = false;
  Uint8List imageInMemory;
  Future<Uint8List> _capturePng() async {
    try {
      inside = true;
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // final directory = (await getExternalStorageDirectory()).path;
      final file = await _localFile;
      file.writeAsBytes(pngBytes);

//      //read img data just tested here. Need to move somewhere else
//      Uint8List imgByte;
//      readContent().then((bytesData) {
//        imgByte = bytesData;
//      });
//
//      // Save img to Gallery
//      final res = await ImageGallerySaver.saveImage(pngBytes);
//      //Upto here Save img to gallery
      print("outside");
      setState(() {
        print("inside");
        imageInMemory = pngBytes;
        inside = false;
      });
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }
//Upto here Test

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
            _controller = newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: () {

            if (_controller.canUndo)
            {
              print("Entered");
              _controller.undo();
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
            if (_controller.canRedo) _controller.redo();
          },
        ),
        IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: () => setState(() {
              multiwidget.clear();
              _controller.clear();
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
              print("true");
            } else {
              print("else");
              type.add(2);
              fontsize.add(20);
              offsets.add(Offset.zero);
              multiwidget.add(value);
              Timer(Duration(seconds: 3), () {
                _capturePng().then((imgValue) {
                  print("capture");
                  if(imgValue != null) {
                    print("capture3");
                  }
                  if(imageInMemory != null){
                    print("capture2");
                    _controller.backgroundImage = Image.memory(imageInMemory);
                  }
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
                              imageInMemory != null ? Container(
                                child: Image.memory(imageInMemory),
                                margin: EdgeInsets.all(10),
                              ) : Container(),
                            ],
                          ),
                        ),
                      )
                  );
                }));
              });



            }),
      ];
    }
    return Scaffold(
        appBar: AppBar(
            title: Text('Painter2 Example'),
            actions: actions,
            bottom: PreferredSize(
              child: DrawBar(_controller),
              preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
            )),
        body: RepaintBoundary(
          key: _globalKey,
          child: Stack(
            children: <Widget>[
              Container(
                //child: Center(
                child: getSwiper(),
                // child: AspectRatio(aspectRatio: 1.0, child: Painter(_controller))
                //),
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
                      print("vvvidya");
//                      scaf.currentState
//                          .showBottomSheet((context) {
//                        return Sliders(
//                          size: f.key,
//                          sizevalue:
//                          fontsize[f.key].toDouble(),
//                        );
//                      });
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
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          if( imageIndex != index) {
            print("Got");
            imageIndex = index;
            PainterController cont = newController();
            return new AspectRatio(aspectRatio: 1.0,
              child: Painter(cont),
            );
          }
          return new AspectRatio(aspectRatio: 1.0,
            child: Painter(_controller),
          );
        },
        autoplay: false,
        itemCount: images.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );

  }

}



class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  child: Slider(
                    value: _controller.thickness,
                    onChanged: (value) => setState(() {
                      _controller.thickness = value;
                    }),
                    min: 1.0,
                    max: 20.0,
                    activeColor: Colors.white,
                  ));
            })),
        ColorPickerButton(_controller, false),
        ColorPickerButton(_controller, true),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

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
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    print("color");
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
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
                    print(v.toInt());
                    fontsize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}

