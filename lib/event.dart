import 'package:flutter/material.dart';
import 'package:SpidyLib/addEvent.dart';
import 'package:SpidyLib/detailEvent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SpidyLib/koneksi.dart';
import 'package:SpidyLib/main.dart';

class event extends StatefulWidget {
  final String userx;
  final String pass;
  event({this.userx, this.pass});

  @override
  _eventState createState() => _eventState();
}

class _eventState extends State<event> {
  ProgressDialog pr;

  List<DocumentSnapshot> GetEvent = List();

  bool loading = false;

  AmbilData() async {
    setState(() {
      loading = true;
    });
    GetEvent = await Koneksi.koneksi.GetEvent();
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
                  builder: (context) => addEvent(
                        reloadData: AmbilData,
                      )));
        },
        label: Text('ADD EVENT'),
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
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: EdgeInsets.fromLTRB(20, 80, 20, 20),
          //   padding: EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //       color: Colors.grey[350],
          //       borderRadius: BorderRadius.circular(20)),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         "Event",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontFamily: "Trueno",
          //             fontWeight: FontWeight.w700,
          //             fontSize: 36),
          //       ),
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width - 220,
          //       ),
          //       Image.asset(
          //         "images/logo.png",
          //         height: 100,
          //       ),
          //     ],
          //   ),
          // ),
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
                    itemCount: GetEvent.length,
                    itemBuilder: (context, i) {
                      final item = GetEvent[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailEvent(
                                        reloadData: AmbilData,
                                        idDocument: item.documentID,
                                        judul_event: item.data['judul_event'],
                                        deskripsi_event:
                                            item.data['deskripsi_event'],
                                        waktu_laksana:
                                            item.data['waktu_laksana'],
                                        gambar: item.data['gambar'],
                                        created: item.data['created'],
                                        users: widget.userx,
                                      )));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(20, 5, 20, 30),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                Image.network(item.data['gambar'],
                                    width: MediaQuery.of(context).size.width),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  item.data['judul_event'],
                                  style: TextStyle(
                                      fontFamily: "Trueno",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21),
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  item.data['deskripsi_event'],
                                  style: TextStyle(
                                      fontFamily: "Trueno",
                                      fontWeight: FontWeight.w200),
                                  maxLines: 3,
                                )
                              ],
                            )),
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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                    onTap: () {},
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
