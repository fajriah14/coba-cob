import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:SpidyLib/editLabalaba.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:SpidyLib/koneksi.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

class detailLabalaba extends StatefulWidget {
  final VoidCallback reloadData;
  final String idDocument;
  final String nama_labalaba;
  final String famili;
  final String spesies;
  final String ordo;
  final String deskripsi_labalaba;
  final String gambar;
  final String created;
  final String users;

  detailLabalaba(
      {this.reloadData,
      this.idDocument,
      this.nama_labalaba,
      this.created,
      this.famili,
      this.spesies,
      this.ordo,
      this.gambar,
      this.deskripsi_labalaba,
      this.users});

  @override
  _detailLabalabaState createState() => _detailLabalabaState();
}

class _detailLabalabaState extends State<detailLabalaba> {
  ProgressDialog pr;

  String nama_labalaba;
  String famili;
  String spesies;
  String ordo;
  String deskripsi_labalaba;
  String gambar;
  String created;

  @override
  void initState() {
    super.initState();
    nama_labalaba = widget.famili;
    famili = widget.famili;
    spesies = widget.spesies;
    ordo = widget.ordo;
    deskripsi_labalaba = widget.deskripsi_labalaba;
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
                          builder: (context) => editLabalaba(
                                reloadData: widget.reloadData,
                                idDocument: widget.idDocument,
                                nama_labalaba: nama_labalaba,
                                famili: famili,
                                spesies: spesies,
                                ordo: ordo,
                                deskripsi_labalaba: deskripsi_labalaba,
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
                            nama_labalaba,
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
                        deskripsi_labalaba,
                        style: TextStyle(
                            fontFamily: "Trueno", fontWeight: FontWeight.w200),
                        textAlign: TextAlign.justify,
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "famili: ",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        famili,
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
                        "spesies : ",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        spesies,
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
                        "ordo : ",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 100),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        ordo,
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
