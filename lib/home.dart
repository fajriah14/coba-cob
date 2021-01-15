import 'package:flutter/material.dart';
import 'package:nandur/addTanaman.dart';
import 'package:nandur/detailTanaman.dart';
import 'package:nandur/event.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nandur/koneksi.dart';
import 'package:nandur/main.dart';

class home extends StatefulWidget {
  final String userz;
  final String pass;

  home({this.userz, this.pass});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  ProgressDialog pr;

  List<DocumentSnapshot> GetTanaman = List();

  bool loading = false;

  AmbilData() async {
    setState(() {
      loading = true;
    });
    GetTanaman = await Koneksi.koneksi.GetTanaman();
    setState(() {
      loading = false;
    });
  }

  String user;
  Future cekoke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user');
  }

  Widget ButtonAdd() {
    if (user != "" && user != null) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => addTanaman(
                        reloadData: AmbilData,
                      )));
        },
        label: Text('ADD TANAMAN'),
        icon: Icon(Icons.note_add),
        backgroundColor: Colors.green[400],
      );
    } else {
      return Container();
    }
  }

  Widget ButtonAddx() {
    if (user != "" && user != null) {
      return GestureDetector(
        onTap: () {
          Logout();
        },
        child: Container(
          child: Text(
            "LOGOUT",
            style: TextStyle(
                fontFamily: "Trueno",
                fontWeight: FontWeight.w700,
                fontSize: 20),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Logout() async {
    pr.show();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("user");
    Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    cekoke();
    AmbilData();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(20, 80, 20, 20),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "images/logo.png",
                  height: 100,
                ),
                Text(
                  "nandur.",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Trueno",
                      fontWeight: FontWeight.w700,
                      fontSize: 36),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 340,
                ),
                Image.asset(
                  "images/kaktus.png",
                  height: 100,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200),
            height: 700,
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey[500]),
                    ),
                  )
                : ListView.builder(
                    itemCount: GetTanaman.length,
                    itemBuilder: (context, i) {
                      final item = GetTanaman[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailTanaman(
                                        reloadData: AmbilData,
                                        idDocument: item.documentID,
                                        nama_tanaman: item.data['nama_tanaman'],
                                        cara_menanam: item.data['cara_menanam'],
                                        cara_merawat: item.data['cara_merawat'],
                                        hasil_tanaman:
                                            item.data['hasil_olahan'],
                                        deskripsi_tanaman:
                                            item.data['deskripsi_tanaman'],
                                        gambar: item.data['gambar'],
                                        created: item.data['created'],
                                        users: widget.userz,
                                      )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 125,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(item.data['gambar']),
                                        fit: BoxFit.fill)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 195,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      item.data['nama_tanaman'],
                                      style: TextStyle(
                                        fontFamily: "Brian",
                                        fontSize: 75,
                                      ),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      item.data['deskripsi_tanaman'],
                                      style: TextStyle(
                                          fontFamily: "Trueno",
                                          fontWeight: FontWeight.w200),
                                      maxLines: 4,
                                      textAlign: TextAlign.justify,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Positioned(
//            top: 100.0,
            left: 0.1,
            right: 0.1,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 40, 20, 5),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Text(
                        "HOME",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => event(
                                    userx: widget.userz,
                                    pass: widget.pass,
                                  )));
                    },
                    child: Container(
                      child: Text(
                        "EVENT",
                        style: TextStyle(
                            fontFamily: "Trueno",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  ButtonAddx(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ButtonAdd(),
    );
  }
}
