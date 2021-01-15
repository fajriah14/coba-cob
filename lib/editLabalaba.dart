import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:SpidyLib/koneksi.dart';
import 'package:intl/intl.dart';

class editLabalaba extends StatefulWidget {
  final VoidCallback reloadData;
  final String idDocument;
  final String nama_labalaba;
  final String famili;
  final String spesies;
  final String ordo;
  final String deskripsi_labalaba;
  final String gambar;
  final String created;

  editLabalaba(
      {this.reloadData,
      this.idDocument,
      this.nama_labalaba,
      this.created,
      this.famili,
      this.spesies,
      this.ordo,
      this.gambar,
      this.deskripsi_labalaba});

  @override
  _editLabalabaState createState() => _editLabalabaState();
}

class _editLabalabaState extends State<editLabalaba> {
  ProgressDialog pr;

  Future<File> file;
  File _image;
  String status = '';
  String _uploadedFileURL;
  String date_now = DateFormat("d / MMMM / y H:mm")
      .format(DateTime.parse(DateTime.now().toString()));

  String _imageUrl;

  TextEditingController nama_labalaba = TextEditingController();
  TextEditingController famili = TextEditingController();
  TextEditingController spesies = TextEditingController();
  TextEditingController deskripsi_lablaba = TextEditingController();
  TextEditingController ordo = TextEditingController();
  FocusNode myFocusNode;

  String gambar;
//  String user;
  String created;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    nama_labalaba.text = widget.nama_labalaba;
    famili.text = widget.famili;
    spesies.text = widget.spesies;
    ordo.text = widget.ordo;
    deskripsi_lablaba.text = widget.deskripsi_labalaba;
    gambar = widget.gambar;
    created = widget.created;
    gambar = widget.gambar;
//    user = widget.user;
    created = widget.created;
  }

  Future<void> Notif() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil update Laba-laba !'),
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future getImageFromGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 20)
        .then((image) {
      setState(() {
        file = ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 20);
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
    if (_image == null) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        Koneksi.koneksi.UpdateTanaman(
            widget.idDocument,
            nama_labalaba.text,
            famili.text,
            spesies.text,
            deskripsi_lablaba.text,
            ordo.text,
            'kosong');
        pr.hide().whenComplete(() {
//          print('sukses');
          Notif();
//        Navigator.pop(context);
        });
      });
    } else {
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
        Koneksi.koneksi.UpdateTanaman(
          widget.idDocument,
          nama_labalaba.text,
          famili.text,
          spesies.text,
          deskripsi_lablaba.text,
          ordo.text,
          _uploadedFileURL,
        );
        pr.hide().whenComplete(() {
          Notif();
//        Navigator.pop(context);
        });
      });
    }
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
            height: 150,
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
          return Container(
            height: 150,
            child: Image.network(
              gambar,
              fit: BoxFit.cover,
            ),
          );
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
                    "Edit Laba-laba",
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: "Trueno",
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 20),
                    child: TextFormField(
                      controller: nama_labalaba,
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
                  SizedBox(
                    height: 20,
                  ),
                  showImage(),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: RaisedButton(
                      onPressed: () {
                        myFocusNode.requestFocus();
                        getImageFromGallery();
                      },
                      child: Text("EDIT GAMBAR"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: TextFormField(
                      focusNode: myFocusNode,
                      controller: deskripsi_lablaba,
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
                    child: TextFormField(
                      controller: famili,
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
                    child: TextFormField(
                      controller: spesies,
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
                    child: TextFormField(
                      controller: ordo,
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
                      },
                      child: Text(
                        "SAVE",
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
