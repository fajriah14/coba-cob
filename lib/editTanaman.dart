import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:nandur/koneksi.dart';
import 'package:intl/intl.dart';
class editTanaman extends StatefulWidget {

  final VoidCallback reloadData;
  final String idDocument;
  final String nama_tanaman;
  final String cara_menanam;
  final String cara_merawat;
  final String hasil_tanaman;
  final String deskripsi_tanaman;
  final String gambar;
  final String created;

  editTanaman({this.reloadData,this.idDocument,this.nama_tanaman,this.created,this.cara_merawat,this.cara_menanam,this.hasil_tanaman,this.gambar,this.deskripsi_tanaman});


  @override
  _editTanamanState createState() => _editTanamanState();
}

class _editTanamanState extends State<editTanaman> {
  ProgressDialog pr;

  Future<File> file;
  File _image;
  String status = '';
  String _uploadedFileURL;
  String date_now = DateFormat("d / MMMM / y H:mm").format(DateTime.parse(DateTime.now().toString()));

  String _imageUrl;

  TextEditingController nama_tanaman = TextEditingController();
  TextEditingController cara_menanam = TextEditingController();
  TextEditingController cara_merawat = TextEditingController();
  TextEditingController deskripsi_tanaman = TextEditingController();
  TextEditingController hasil_tanaman = TextEditingController();
  FocusNode myFocusNode;

  String gambar;
//  String user;
  String created;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    nama_tanaman.text = widget.nama_tanaman;
    cara_menanam.text = widget.cara_menanam;
    cara_merawat.text = widget.cara_merawat;
    hasil_tanaman.text = widget.hasil_tanaman;
    deskripsi_tanaman.text = widget.deskripsi_tanaman;
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
          title: Text('Berhasil update Tanaman !'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

              ],
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
    await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 20).then((image) {
      setState(() {
        file = ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 20);
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
    if(_image == null){
      Future.delayed(Duration(seconds: 3)).then((value) {
        Koneksi.koneksi.UpdateTanaman(widget.idDocument,nama_tanaman.text,cara_menanam.text,cara_merawat.text,deskripsi_tanaman.text,hasil_tanaman.text,'kosong');
        pr.hide().whenComplete(() {
//          print('sukses');
          Notif();
//        Navigator.pop(context);
        });
      });
    }else{
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
        Koneksi.koneksi.UpdateTanaman(widget.idDocument,nama_tanaman.text,cara_menanam.text,cara_merawat.text,deskripsi_tanaman.text,hasil_tanaman.text,_uploadedFileURL,);
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
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
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
                    "EDIT TANAMAN",
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: "Trueno",
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 20),
                    child: TextFormField(
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
                    child: TextFormField(
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
                    child: TextFormField(
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
                    child: TextFormField(
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
