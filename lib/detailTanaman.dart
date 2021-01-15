import 'package:flutter/material.dart';
import 'package:nandur/editTanaman.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:nandur/koneksi.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

class detailTanaman extends StatefulWidget {
  final VoidCallback reloadData;
  final String idDocument;
  final String nama_tanaman;
  final String cara_menanam;
  final String cara_merawat;
  final String hasil_tanaman;
  final String deskripsi_tanaman;
  final String gambar;
  final String created;
  final String users;

  detailTanaman(
      {this.reloadData,
      this.idDocument,
      this.nama_tanaman,
      this.created,
      this.cara_merawat,
      this.cara_menanam,
      this.hasil_tanaman,
      this.gambar,
      this.deskripsi_tanaman,
      this.users});

  @override
  _detailTanamanState createState() => _detailTanamanState();
}

class _detailTanamanState extends State<detailTanaman> {
  ProgressDialog pr;

  String nama_tanaman;
  String cara_menanam;
  String cara_merawat;
  String hasil_tanaman;
  String deskripsi_tanaman;
  String gambar;
  String created;

  @override
  void initState() {
    super.initState();
    nama_tanaman = widget.nama_tanaman;
    cara_menanam = widget.cara_menanam;
    cara_merawat = widget.cara_merawat;
    hasil_tanaman = widget.hasil_tanaman;
    deskripsi_tanaman = widget.deskripsi_tanaman;
    gambar = widget.gambar;
    created = widget.created;
//    cekokex();
  }

  HapusData(String id_document) {
    pr.show();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Koneksi.koneksi.HapusTanaman(widget.idDocument);
      pr.hide().whenComplete(() {
        widget.reloadData();
        Navigator.pop(context);
      });
    });
  }

  Widget ButtonAddx() {
    if (widget.users != null) {
      return Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: "btnEdit",
                label: Text("EDIT"),
                icon: Icon(Icons.edit),
                backgroundColor: Colors.orange,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => editTanaman(
                                reloadData: widget.reloadData,
                                idDocument: widget.idDocument,
                                nama_tanaman: nama_tanaman,
                                cara_menanam: cara_menanam,
                                cara_merawat: cara_merawat,
                                hasil_tanaman: hasil_tanaman,
                                deskripsi_tanaman: deskripsi_tanaman,
                                gambar: gambar,
                                created: created,
                              )));
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: "btnDelete",
              label: Text("DELETE"),
              icon: Icon(Icons.delete_forever),
              backgroundColor: Colors.red,
              onPressed: () {
                HapusData(widget.idDocument);
              },
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);

    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(20, 80, 20, 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(gambar),
                                  fit: BoxFit.fill)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 130,
                          child: Text(
                            nama_tanaman,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Brian",
                              fontSize: 60,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 400,
                        ),
                        Image.asset(
                          "images/logo.png",
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        deskripsi_tanaman,
                        style: TextStyle(
                            fontFamily: "Trueno", fontWeight: FontWeight.w200),
                        textAlign: TextAlign.justify,
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "CARA MENANAM : ",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        cara_menanam,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Trueno",
                          fontWeight: FontWeight.w200,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "CARA MERAWAT : ",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        cara_merawat,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Trueno",
                          fontWeight: FontWeight.w200,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "HASIL OLAHAN : ",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 100),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        hasil_tanaman,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Trueno",
                          fontWeight: FontWeight.w200,
                        ),
                      )),
                ],
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
                      )))
            ],
          ),
        ),
        floatingActionButton: ButtonAddx());
  }
}
