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
  void initState(){
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

    var res = await CallApi().getData('cities/'+ (this.selectedCountry as String));
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        this.cities = body;
      });
    }
  }
  void _login(c, email, password) async {
      var userData = {
        "email": email,
        "password": password,
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
            "roles":["user-participant"], //Rol por defecto usuario normal,
            "id_city": selectedCity, 
            "public": 1,
            "password": _password.text
          };

          var response = await CallApi().postData(userData, "users");
          var body = jsonDecode(response.body);
          print(body);
          if(body["success"] == true){
            this._login(c, _email.text, _password.text);
          }else{
            ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text("Ocurrio un error"),
                backgroundColor: Colors.redAccent,
              )
            );
          }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("There are empty inputs")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _globalKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 120.0, 0.0, 0.0),
                    child: Text(
                      "Registro",
                      style: TextStyle(
                          fontSize: 80.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
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
                            fontWeight: FontWeight.bold, color: Colors.grey),
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
            )
          ],
        )
      );
  }
}
