import 'dart:convert';
import 'package:flutter/material.dart';
import 'api/api_service.dart';
import 'package:e_learnig_clone/root_app.dart';
import 'package:e_learnig_clone/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApp extends StatefulWidget {
  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      key: _globalKey,
      backgroundColor:Color.fromRGBO(246, 246, 246, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent
              ),
              /*borderRadius: BorderRadius.all(Radius.circular(200)),*/
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),

              image: DecorationImage(
                image: AssetImage("assets/images/curie.png"),
                fit: BoxFit.cover
              )
            ),
          ),
          



          Container(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 0.0),
                  child: Text(
                    "Inicia sesión",
                    style:
                        TextStyle(
                          fontSize: 50.0, 
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(100, 70, 215,1)
                        ),
                  ),
                )
              ],
            ),
          ),



          
          Container(
            padding: EdgeInsets.only(top: 25.00, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  
                  controller: _email,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color.fromRGBO(100, 70, 215,1),
                        ),
                      labelText: "E-MAIL",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Color.fromRGBO(100, 70, 215,1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(100, 70, 215,1)))),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.key,
                        color: Color.fromRGBO(100, 70, 215,1),
                      ),
                      labelText: "CONTRASEÑA",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Color.fromRGBO(100, 70, 215,1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(100, 70, 215,1)))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(top: 15.0, left: 20.0),
                  child: InkWell(
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                          color: Color.fromRGBO(241, 206, 156, 1),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Color.fromARGB(255, 133, 109, 231),
                    color: Color.fromRGBO(100, 70, 215,1),
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        _login(context);
                      },
                      child: Center(
                        child: Text("INGRESAR",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(100, 70, 215,1),
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: GestureDetector(
                          onTap: () {
                            _register(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /*Center(
                                child: ImageIcon(
                                    AssetImage('assets/images/edit.png')),
                              ),*/
                              Center(
                                child: Text('REGÍSTRARSE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(100, 70, 215,1)
                                    )
                                  ),
                              )
                            ],
                          ),
                        )
                      )
                    )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _login(c) async {
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      var userData = {
        "email": _email.text,
        "password": _password.text,
        "remember": 1
      };
      var res = await CallApi().postData(userData, 'login');
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        print(body["token"]);
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['token']);
        localStorage.setString('user', json.encode(body['user']));
        Navigator.of(c).push(MaterialPageRoute(
          builder: (c) => RootApp()
        ));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("There are empty inputs")));
    }
  }
  void _register(c) {
    Navigator.of(c).push(MaterialPageRoute(builder: (c) => RegisterPage()));
  }
}
