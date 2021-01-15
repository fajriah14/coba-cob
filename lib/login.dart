import 'package:flutter/material.dart';
import 'package:SpidyLib/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  ProgressDialog pr;

  // ignore: non_constant_identifier_names
  Future<void> Notif() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pemberitahuan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Username atau password anda salah !'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(key, value);
  }

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool loading = false;

  String user;
  String pass;
//  int level;
  // ignore: non_constant_identifier_names
  var login_berhasil = false;
  CollectionReference db = Firestore.instance.collection('user');

  // ignore: non_constant_identifier_names
  LoginNow() async {
    pr.show();
    QuerySnapshot result = await db
        .where('username', isEqualTo: username.text)
        .where('password', isEqualTo: password.text)
        .limit(1)
        .getDocuments();
    Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {
        if (result.documents.length == 1) {
          login_berhasil = true;
          user = username.text;
          pass = password.text;
          save('user', user);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => home(
                        userz: user,
                        pass: pass,
                      )));
        } else {
          login_berhasil = false;
          Notif();
        }
        username.text = "";
        password.text = "";
      });
    });

//    List<DocumentSnapshot> documents = result.documents;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      "images/logo.png",
                      height: 100,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(50, 100, 50, 10),
//                    height: MediaQuery.of(context).size.height - 430,
                      width: MediaQuery.of(context).size.width,
//                    margin: EdgeInsets.only(top: 80),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(200),
                              topRight: Radius.circular(200))),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: TextStyle(
                                    fontFamily: "Trueno",
                                    fontWeight: FontWeight.w200,
                                    color: Colors.grey)),
                          ),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                    fontFamily: "Trueno",
                                    fontWeight: FontWeight.w200,
                                    color: Colors.grey)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              LoginNow();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue[400],
                              ),
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Trueno"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 15, top: 0),
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
          )
        ],
      ),
    );
  }
}
