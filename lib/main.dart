import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey globalKey = new GlobalKey();

  List<String> list = [];
  List<double> TOP = [];
  List<double> LEFT = [];
  List<double> ANGLE = [];
  List<double> SIZE = [];
  List<Color> color = [];
  List<String> textStyle = [];

  List<Widget> Textcell = List<Widget>();
  int total = 0;
  Random random = new Random();
  String headtext = "";
  bool isclick = false;
  bool visible = true;
  Io.File image;
  double topi = 50.0;
  double lefti = 50.0;
  double size = 40.0;
  double ang = 0.0;
  ByteData byteData;
  int randomNumber;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List _Colors = ["Black", "Red", "Green", "White", "Yellow", "Blue", "Orange", "Brown", "Purple", "Pink", "Indigo"];
  List textstyle = ["Lobster", "Dark", "Marker", "Roboto", "Yellowtail", "Pangolin", "Piedra", "Indie", "Into_light", "Caveat"];
  List<DropdownMenuItem<String>> _dropDownMenuItemsTextstyle;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _SelectedText;
  String _selectedColors;

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_Colors);
    _selectedColors = _dropDownMenuItems[0].value;
    _dropDownMenuItemsTextstyle = buildAndGetDropDownMenuItemstext(textstyle);
    _SelectedText = _dropDownMenuItemsTextstyle[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List colors) {
    List<DropdownMenuItem<String>> items = List();
    for (String color in _Colors) {
      items.add(DropdownMenuItem(value: color, child: Text(color)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItemstext(List text) {
    List<DropdownMenuItem<String>> items = List();
    for (String text in textstyle) {
      items.add(DropdownMenuItem(value: text, child: Text(text,
        style: TextStyle(
          fontFamily: text,
        ),
      )));
    }
    return items;
  }

  void changedDropDownItem(String acolor) {
    setState(() {
      _selectedColors = acolor;
    });
  }

  void changedDropDownItemText(String atext) {
    setState(() {
      _SelectedText = atext;
    });
  }

  getimage(){
    setState(() {
      isclick = !isclick;
    });
  }

  Color choosecolor(){
    if(_selectedColors == "Black"){
      return Colors.black;
    }else if(_selectedColors == "Red"){
      return Colors.red;
    }else if(_selectedColors == "Green"){
      return Colors.green;
    }else if(_selectedColors == "White"){
      return Colors.white;
    }else if(_selectedColors == "Yellow"){
      return Colors.yellow;
    }else if(_selectedColors == "Blue"){
      return Colors.blue;
    }else if(_selectedColors == "Orange"){
      return Colors.orange;
    }else if(_selectedColors == "Brown"){
      return Colors.brown;
    }else if(_selectedColors == "Purple"){
      return Colors.purple;
    }else if(_selectedColors == "Pink"){
      return Colors.pink;
    }else if(_selectedColors == "Indigo"){
      return Colors.indigo;
    }
  }

  takeScreenShot() async{
    randomNumber = random.nextInt(1000);
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 5.0);
    final directory = (await getApplicationDocumentsDirectory()).path;
    byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    Io.File imgFile =new Io.File('$directory/mememaker$randomNumber.jpg');
    imgFile.writeAsBytes(pngBytes);
    await imgFile.writeAsBytesSync(pngBytes);
    GallerySaver.saveImage(imgFile.path, albumName: "mememaker");
  }

  Future pickimage(bool iscamera) async{
    Io.File img;
    if(iscamera){
      img = await ImagePicker.pickImage(source: ImageSource.camera);
    }else{
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      image = img;
      isclick = !isclick;
    });
  }

  Widget getthebody(){
    double wid = MediaQuery.of(context).size.width;
    if(!isclick){
      return SingleChildScrollView(child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 1,),
              RepaintBoundary(
                key: globalKey,
                //stack
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.black12,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    ),
                    image == null ? Image.asset('assets/meme.jpg',):
                    Image.file(image, height: 300, width: MediaQuery.of(context).size.width,),
                    for (int i=0;i<total;i++)Row(
                      children: <Widget>[
                        Container(
                          width: LEFT[i],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: TOP[i],
                            ),
                            Container(
                              child: Transform.rotate(
                                angle: ANGLE[i]*pi/180,
                                child: Text(
                                  list[i],
                                  style: TextStyle(
                                    fontFamily: textStyle[i],
                                    fontSize: SIZE[i],
                                    color: color[i],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: lefti,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: topi,
                            ),
                            Container(
                              child: Transform.rotate(
                                angle: ang*pi/180,
                                child: Text(headtext,
                                  style: TextStyle(
                                    fontFamily: _SelectedText,
                                    fontSize: size,
                                    color: choosecolor(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //variable text
              new TextField(
                onTap: () {visible = false;},
                onEditingComplete: () {visible = true;},
                onChanged: (val){
                  setState(() {
                    headtext = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Add Text",
                ),
              ),
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //1
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Column(
                      children: <Widget>[
                        //arrowup
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            topi -= 10;
                            if(topi <= 0){
                              topi = 0;
                            }
                          });
                        },
                          child: Icon(Icons.arrow_upward),
                        ),
                        //arrowdown
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            topi += 10;
                            if(topi >= 340){
                              topi = 340;
                            }
                          });
                        },
                          child: Icon(Icons.arrow_downward),
                        ),
                        //increasesize
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            size += 5;
                            if(size >= 150){
                              size = 150;
                            }
                          });
                        },
                          child: Icon(Icons.add),
                        ),
                        //rotateleft
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            ang -= 10;
                            ang %= 360;
                          });
                        },
                          child: Icon(Icons.rotate_left),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              DropdownButton(
                                value: _selectedColors,
                                items: _dropDownMenuItems,
                                onChanged: changedDropDownItem,
                              ),
                              Icon(Icons.color_lens),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //2
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Column(
                      children: <Widget>[
                        //done
                        RaisedButton(onPressed: () {
                          final snackbar = SnackBar(
                            content: Text("Meme Updated"),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                                label: "Ok",
                                onPressed: () {
                                  SnackBar(content: Text(""),
                                    duration: Duration(microseconds: 1),);
                                }
                            ),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                          setState(() {
                            list.add(headtext);
                            LEFT.add(lefti);
                            TOP.add(topi);
                            SIZE.add(size);
                            ANGLE.add(ang);
                            textStyle.add(_SelectedText);
                            color.add(choosecolor());
                            headtext = "";
                            total+=1;
                            lefti = 50.0;
                            topi = 50.0;
                            size = 40.0;
                            ang = 0.0;
                            _SelectedText = _dropDownMenuItemsTextstyle[0].value;
                            _selectedColors = _dropDownMenuItems[0].value;
                          });
                        },
                          child: Icon(Icons.done),
                        ),
                        //save
                        RaisedButton(onPressed: () async {
                          final snackbar = SnackBar(
                            content: Text("Saving . . ."),
                            duration: Duration(seconds: 3),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                          await takeScreenShot();
                          final snackBar = SnackBar(
                            content: Text("Saved."),
                            duration: Duration(seconds: 1),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                          child: Icon(Icons.save),
                        ),
                        RaisedButton(onPressed: () async {
                          final snackbar = SnackBar(
                            content: Text("Saving . . ."),
                            duration: Duration(seconds: 3),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                          await takeScreenShot();
                          final snackBar = SnackBar(
                            content: Text("Saved."),
                            duration: Duration(seconds: 1),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                            await Share.file('mememaker$randomNumber.png', 'mememaker$randomNumber.jpg', byteData.buffer.asUint8List(), 'image/png', text: 'Wants to make meme like this? download the app from https://github.com/Tushargupta9800');
                        },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.save),
                              Text('&',
                              style: TextStyle(
                                fontSize: 15,
                              ),),
                              Icon(Icons.share),
                            ],
                          ),
                        ),
                        Container(
                          height: 95.0,
                        )
                      ],
                    ),
                  ),
                  //3
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0,),
                    child: Column(
                      children: <Widget>[
                        //arrowback
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            lefti -= 10;
                            if(lefti <= 0){
                              lefti = 0;
                            }
                          });
                        },
                          child: Icon(Icons.arrow_back),
                        ),
                        //arrowforward
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            lefti += 10;
                            if(lefti >= wid){
                              lefti = wid;
                            }
                          });
                        },
                          child: Icon(Icons.arrow_forward),
                        ),
                        //sizeminus
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            size -= 5;
                            if(size <= 5){
                              size = 5;
                            }
                          });
                        },
                          child: Icon(Icons.remove),
                        ),
                        //rotateright
                        RaisedButton(onPressed: () {
                          setState(() {
                            visible = true;
                            ang += 10;
                            ang %= 360;
                          });
                        },
                          child: Icon(Icons.rotate_right),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              DropdownButton(
                                value: _SelectedText,
                                items: _dropDownMenuItemsTextstyle,
                                onChanged: changedDropDownItemText,
                              ),
                              Icon(Icons.text_fields),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          )
      ));
    }else{
      return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2 - 150),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () async{
                        await pickimage(true);
                        list = [];
                        SIZE = [];
                        TOP = [];
                        LEFT = [];
                        color = [];
                        textStyle = [];
                        total = 0;
                        headtext = "";
                        ANGLE = [];
                        _SelectedText = _dropDownMenuItemsTextstyle[0].value;
                        _selectedColors = _dropDownMenuItems[0].value;
                      },
                      child: Icon(Icons.camera_alt,
                        size: 120,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text('CLICK A PICTURE',
                    style: TextStyle(
                      fontFamily: 'Piedra',
                      color: Colors.blue[900],
                      decoration: TextDecoration.overline,
                    ),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        pickimage(false);
                        list = [];
                        SIZE = [];
                        TOP = [];
                        color = [];
                        textStyle = [];
                        headtext = "";
                        total = 0;
                        LEFT = [];
                        ANGLE = [];
                        _SelectedText = _dropDownMenuItemsTextstyle[0].value;
                        _selectedColors = _dropDownMenuItems[0].value;
                      },
                      child: Icon(Icons.add_photo_alternate,
                        size: 120,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text('FIND IN GALLERY',
                      style: TextStyle(
                        fontFamily: 'Piedra',
                        color: Colors.blue[900],
                        decoration: TextDecoration.overline,
                      ),),
                  ],
                ),
              ],
            ),
            Text('\n\nAbout Me:-\n\nTushar Gupta is the one behind this beautiful Application\n'
                'who did all the work of frontend as well as backend of\n'
                'this project You can find me on Github along with my\n'
                'other projects. My Github handle:-\n '),
            InkWell(
                child: new Text('Click here:- https://github.com/Tushargupta9800',
                style: TextStyle(
                  color: Colors.redAccent,
                ),),
                onTap: () => launch('https://github.com/Tushargupta9800')
            ),
            Text(
              'Dont forget to follow me and star my repositories 😉'
            )
          ],
        ),
      );
    }
  }

  Widget getthebutton(){
    if(visible){
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, (MediaQuery.of(context).size.width)/2 - 45, 0.0),
        child: Container(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.red[900],
            onPressed: () => getimage(),
            child: Icon(Icons.add_circle_outline,
              size: 50,),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Center(child: Text('MeMe Maker',
          style: TextStyle(
            fontFamily: 'meme',
            fontSize: 30,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),),
      ),
      body: getthebody(),
      floatingActionButton: getthebutton(),
    );
  }
}