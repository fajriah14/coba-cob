import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:nandur/login.dart';
import 'package:nandur/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nandur',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg1.png"), fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/logo.png",
                height: 250,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(30, 20, 30, 50),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 180,
                  child: Text(
                      "Nandur merupakan aplikasi pertanian yang berisi informasi cara penanaman, perawatan serta hasil olahannya. Aplikasi ini juga terdapat rangkaian event-event pertanian yang akan diadakan",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Trueno"),
                      textAlign: TextAlign.justify),
                ),
              ),
              SizedBox(
                width: 200,
                child: RaisedButton(
                  color: Colors.green[400],
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => home()));
                  },
                  child: Text(
                    "LET'S GET STARTED",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Trueno",
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: RaisedButton(
                  color: Colors.green[400],
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => login()));
                  },
                  child: Text(
                    "LOGIN ADMIN",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Trueno",
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
