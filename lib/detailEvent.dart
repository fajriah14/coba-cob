import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SpidyLib/editEvent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:SpidyLib/koneksi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class detailEvent extends StatefulWidget {
  final VoidCallback reloadData;
  final String idDocument;
  final String judul_event;
  final String deskripsi_event;
  final String waktu_laksana;
  final String gambar;
  final String created;
  final String users;

  detailEvent(
      {this.reloadData,
      this.idDocument,
      this.judul_event,
      this.deskripsi_event,
      this.waktu_laksana,
      this.gambar,
      this.created,
      this.users});

  @override
  _detailEventState createState() => _detailEventState();
}

class _detailEventState extends State<detailEvent> {
  ProgressDialog pr;

  String judul_event;
  String deskripsi_event;
  String waktu_pelaksanaan;
  String gambar;
  String created;

  String user;
  Future cekoke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user');
  }

  @override
  void initState() {
    super.initState();
    cekoke();
    judul_event = widget.judul_event;
    deskripsi_event = widget.deskripsi_event;
    waktu_pelaksanaan = widget.waktu_laksana;
    gambar = widget.gambar;
    created = widget.created;
  }

  Widget ButtonAddx() {
    if (widget.users != null) {
      return Padding(
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
                      builder: (context) => editEvent(
                            reloadData: widget.reloadData,
                            idDocument: widget.idDocument,
                            judul_event: widget.judul_event,
                            deskripsi_event: widget.deskripsi_event,
                            waktu_pelaksanaan: widget.waktu_laksana,
                            gambar: widget.gambar,
                            created: widget.created,
                          )));
            },
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(0),
      );
    }
  }

  Widget ButtonAddxx() {
    if (widget.users != null) {
      return Align(
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
      );
    } else {
      return Align();
    }
  }

  HapusData(String id_document) {
    pr.show();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Koneksi.koneksi.HapusEvent(widget.idDocument);
      pr.hide().whenComplete(() {
        widget.reloadData();
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);

    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          title: Padding(
            padding: EdgeInsets.only(left: 10),
//          child: Row(
//            children: <Widget>[
//              Text("Stikes",
//                style: TextStyle(
//                  fontFamily: 'Roboto-Bold',
//                  fontSize: 25,
//                  color: Colors.white,
//                  fontWeight: FontWeight.w500,
//                ),
//              ),
//              Text(" Banyuwangi",
//                style: TextStyle(
//                  fontFamily: 'Roboto-Bold',
//                  fontSize: 25,
//                  color: Colors.white,
//                  fontWeight: FontWeight.w500,
//                ),
//              ),
//              Text(" Absensi",
//                style: TextStyle(
//                  fontFamily: 'Roboto-Light',
//                  fontSize: 25,
//                  color: Colors.white,
//                ),
//              ),
//            ],
//          ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
//                Row(
//                  children: <Widget>[
//                    Container(
//                        padding: EdgeInsets.all(10),
//                        child: GestureDetector(
//                            onTap: () {
//                              Navigator.pop(context);
//                            },
//                            child: Icon(
//                              Icons.arrow_back,
//                              size: 30,
//                              color: Colors.black,
//                            )))
//                  ],
//                ),
                Container(
//                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Container(
//                        width: 400,
//                        height: 400,
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Image.network(gambar),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 5),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            judul_event,
                            style: TextStyle(
                                fontFamily: "Trueno",
                                fontWeight: FontWeight.w700,
                                fontSize: 23),
                            textAlign: TextAlign.justify,
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            deskripsi_event,
                            style: TextStyle(
                                fontFamily: "Trueno",
                                fontWeight: FontWeight.w200),
                            textAlign: TextAlign.justify,
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Tempat & Waktu Pelaksanaan",
                            style: TextStyle(
                                fontFamily: "Trueno",
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            waktu_pelaksanaan,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: "Trueno",
                              fontWeight: FontWeight.w200,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            ButtonAddx(),
            ButtonAddxx(),
          ],
        ));
  }
}
