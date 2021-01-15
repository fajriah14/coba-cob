import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:nandur/koneksi.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

class addTanaman extends StatefulWidget {
  final VoidCallback reloadData;

  addTanaman({this.reloadData});

  @override
  _addTanamanState createState() => _addTanamanState();
}

class _addTanamanState extends State<addTanaman> {
  ProgressDialog pr;

  Future<File> file;
  File _image;
  String status = '';
  String _uploadedFileURL;
  String date_now = DateTime.now().millisecondsSinceEpoch.toString();
//  String date_now = DateFormat("d / MMMM / y H:mm").format(DateTime.parse(DateTime.now().toString()));

  String _imageUrl;

  TextEditingController nama_tanaman = TextEditingController();
  TextEditingController cara_menanam = TextEditingController();
  TextEditingController cara_merawat = TextEditingController();
  TextEditingController deskripsi_tanaman = TextEditingController();
  TextEditingController hasil_tanaman = TextEditingController();

  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  Future<void> Notif() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil menambahkan Tanaman !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                widget.reloadData();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future getImageFromGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Future uploadFile() async {
    pr.show();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');

    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      Koneksi.koneksi.AddTanaman(
          nama_tanaman.text,
          cara_menanam.text,
          cara_merawat.text,
          deskripsi_tanaman.text,
          hasil_tanaman.text,
          _uploadedFileURL,
          date_now);
      pr.hide().whenComplete(() {
        Notif();
//        Navigator.pop(context);
      });
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
//          tmpFile = snapshot.data;
//          base64Image = base64Encode(snapshot.data.readAsBytesSync());
//          print(base64Image);
          return Container(
            height: 400,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(20, 80, 20, 20),
              child: Column(
                children: <Widget>[
                  Text(
                    "ADD TANAMAN",
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: "Trueno",
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 20),
                    child: TextField(
                      controller: nama_tanaman,
                      style: TextStyle(
                          fontFamily: "Trueno", fontWeight: FontWeight.w200),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Masukkan Nama Tanaman',
                          labelStyle: TextStyle(
                              fontFamily: "Trueno",
                              fontWeight: FontWeight.w200),
                          prefixIcon: Icon(Icons.new_releases)),
                    ),
                  ),
                  Container(
                    child: new Container(
                      height: 100,
//                width:250,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                              1.0, // Move to right 10  horizontally
                              1.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                      ),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(6.0)),
                        onPressed: () {
                          myFocusNode.requestFocus();
                          getImageFromGallery();
                        },
                        child: new Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.blue,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 4),
                                          child: Text(
                                            'GAMBAR',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
//                                                  fontFamily: 'Roboto-Bold',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  showImage(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: TextField(
                      focusNode: myFocusNode,
                      controller: deskripsi_tanaman,
                      style: TextStyle(
                          fontFamily: "Trueno", fontWeight: FontWeight.w200),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Masukkan Deskripsi Tanaman',
                          labelStyle: TextStyle(
                              fontFamily: "Trueno",
                              fontWeight: FontWeight.w200)),
                      maxLines: 15,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: TextField(
                      controller: cara_menanam,
                      style: TextStyle(
                          fontFamily: "Trueno", fontWeight: FontWeight.w200),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Masukkan Cara Menanam Tanaman',
                          labelStyle: TextStyle(
                              fontFamily: "Trueno",
                              fontWeight: FontWeight.w200)),
                      maxLines: 15,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: TextField(
                      controller: cara_merawat,
                      style: TextStyle(
                          fontFamily: "Trueno", fontWeight: FontWeight.w200),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Masukkan Cara Merawat Tanaman',
                          labelStyle: TextStyle(
                              fontFamily: "Trueno",
                              fontWeight: FontWeight.w200)),
                      maxLines: 15,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: TextField(
                      controller: hasil_tanaman,
                      style: TextStyle(
                          fontFamily: "Trueno", fontWeight: FontWeight.w200),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Masukkan Hasil Olahan Tanaman',
                          labelStyle: TextStyle(
                              fontFamily: "Trueno",
                              fontWeight: FontWeight.w200)),
                      maxLines: 15,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: RaisedButton(
                      onPressed: () {
                        uploadFile();
//                    print(DateTime.now().millisecondsSinceEpoch);
                      },
                      child: Text(
                        "TAMBAHKAN TANAMAN",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700),
                      ),
                      color: Colors.green[400],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 15, top: 40),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ))),
          ],
        ),
      ),
    );
  }
}
