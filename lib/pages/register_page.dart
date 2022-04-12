import 'package:flutter/material.dart';
import 'package:e_learnig_clone/api/api_service.dart';
import 'dart:convert';
import 'package:e_learnig_clone/root_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _phone = TextEditingController();

  String? selectedCountry;
  String? selectedCity;
  List? countries;
  List? cities;

  @override
  void initState() {
    this.getCountries();
  }

  getCountries() async {
    var res = await CallApi().getData('countries');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        this.countries = body;
      });
    }
  }

  getCities() async {
    setState(() {
      this.selectedCity = null;
      this.cities = null;
    });

    var res =
        await CallApi().getData('cities/' + (this.selectedCountry as String));
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        this.cities = body;
      });
    }
  }

  void _login(c, email, password) async {
    var userData = {"email": email, "password": password, "remember": 1};
    var res = await CallApi().postData(userData, 'login');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      print(body["token"]);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      Navigator.of(c).push(MaterialPageRoute(builder: (c) => RootApp()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error")));
    }
  }

  void _register(c) async {
    if (_email.text.isNotEmpty &&
        _password.text.isNotEmpty &&
        _name.text.isNotEmpty &&
        _surname.text.isNotEmpty &&
        _phone.text.isNotEmpty &&
        this.selectedCity != null) {
      var userData = {
        "name": _name.text,
        "surname": _name.text,
        "email": _email.text,
        "summary": "",
        "phone_number": _phone.text,
        "roles": ["user-participant"], //Rol por defecto usuario normal,
        "id_city": selectedCity,
        "public": 1,
        "password": _password.text
      };

      var response = await CallApi().postData(userData, "users");
      var body = jsonDecode(response.body);
      print(body);
      if (body["success"] == true) {
        this._login(c, _email.text, _password.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Ocurrio un error"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("There are empty inputs")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor:Color.fromRGBO(246, 246, 246, 1),
        key: _globalKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 70.0,
            ),
            Container(
              child: Image.asset(
                "assets/images/LOGO2.png",
              ),
              height: 70,
              padding: EdgeInsets.only(bottom: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  /*borderRadius: BorderRadius.all(Radius.circular(200)),*/
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  )
                ),
                  /*
                  image: DecorationImage(
                      image: AssetImage("assets/images/curie.png"),
                      fit: BoxFit.cover)
                  ),*/
                  
            ),
            Container(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20),
              child: TextField(
                    controller: _name,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromRGBO(100, 70, 215,1),
                        ),
                      labelText: "NOMBRE",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Color.fromRGBO(100, 70, 215,1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(100, 70, 215,1)
                        )
                      )
                    ),
                  ),
            ),
             Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                    controller: _surname,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.subject,
                        color: Color.fromRGBO(100, 70, 215,1),
                        ),
                      labelText: "APELLIDOS",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Color.fromRGBO(100, 70, 215,1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(100, 70, 215,1)
                        )
                      )
                    ),
                  ),  
            ),

            Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: _email,
                obscureText: false,
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
                          borderSide: BorderSide(color: Color.fromRGBO(100, 70, 215,1)
                        )
                      )
                    ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: _phone,
                obscureText: false,
                decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color.fromRGBO(100, 70, 215,1),
                        ),
                      labelText: "TELEFONO",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Color.fromRGBO(100, 70, 215,1)
                        ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(100, 70, 215,1)
                        )
                      )
                    ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: _password,
                obscureText: true,
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
                  fontWeight: FontWeight.w300, color: Color.fromRGBO(100, 70, 215,1)
                        ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(100, 70, 215,1)
                        )
                      )
                    ),
              ),
            ),
            Container(
              height: 80,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      isDense: true,
                      isExpanded: true,
                      value: selectedCountry,
                      iconSize: 30,
                      icon: (null),
                      style:TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(100, 70, 215,1),
                          fontSize: 16
                      ),
                      hint: Text(
                        'SELECCIONA TU PAÍS',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(100, 70, 215,1),
                          fontSize: 16
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountry = newValue as String;
                          getCities();
                        });
                      },
                      items: countries?.map((e) {
                            return new DropdownMenuItem(
                              child: Text(e["name"]),
                              value: e['id'].toString(),
                            );
                          }).toList() ??
                          [],
                    ),
                  ),
              ),
              )
            ),
            Container(
              height: 80,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: selectedCity,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(100, 70, 215,1),
                          fontSize: 16
                      ),
                  hint: Text(
                    "SELECCIONA UNA CIUDAD",
                    style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(100, 70, 215,1),
                          fontSize: 16
                      ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCity = newValue as String;
                    });
                  },
                  items: cities?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item["name"]),
                          value: item["id"].toString(),
                        );
                      })?.toList() ??
                      [],
                ),
              )),
              )
            ),
            Container(
                  height: 60.0,
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Color.fromARGB(255, 133, 109, 231),
                    color: Color.fromRGBO(100, 70, 215,1),
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        _register(context);
                      },
                      child: Center(
                        child: Text("REGISTRARSE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),

                /*
            Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.blueAccent,
                color: Colors.blue,
                elevation: 7.0,
                child: GestureDetector(
                  onTap: () {
                    _register(context);
                  },
                  child: Center(
                    child: Text(
                      "REGISTRARSE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                ),
              )
            ),*/
            /*
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _name,
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: "NOMBRE",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _surname,
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: "APELLIDOS",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _email,
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: "CORREO",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _phone,
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: "TELEFONO",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "CONTRASEÑA",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          value: selectedCountry,
                          iconSize: 30,
                          icon: (null),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                          hint: Text('SELECCIONA TU PAÍS'),
                          onChanged: (String? newValue){
                            setState(() {
                              selectedCountry = newValue as String;
                              getCities();

                            });
                          },
                          items: countries?.map((e){
                            return new DropdownMenuItem(
                              child: Text(e["name"]),
                              value: e['id'].toString(),
                            );
                          }).toList() ?? [],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  DropdownButtonHideUnderline(
                    
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child:  DropdownButton<String>(
                        isDense: true,
                        isExpanded: true,
                        value: selectedCity,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16
                        ),
                        hint: Text("SELECCIONA UNA CIUDAD"),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCity = newValue as String;
                          });
                        },
                        items: cities?.map((item){
                          return new DropdownMenuItem(
                            child: new Text(item["name"]),
                            value: item["id"].toString(),
                          );
                        })?.toList() ?? [],
                      ),
                    )
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.blueAccent,
                    color: Colors.blue,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        _register(context);
                      },
                      child: Center(
                        child: Text("REGISTRARSE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                      ),
                    ),
                  ),
                ),

                ],
              ),
            )*/
          ],
        ));
  }
}
