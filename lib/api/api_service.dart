import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi{
    final String _url = 'http://10.0.2.2:8000/api/';
    
    postData(data, apiUrl) async {
      try{
        //var token = await _getToken(); 
        /*var headers = _setHeaders();
        
        print(token + "ELTOKEN");*/
        var fullUrl = _url + apiUrl;
        return await http.post(
            Uri.parse(fullUrl), 
            body: jsonEncode(data), 
            headers: _setHeaders()              
        );
      }
      catch(e){
        print(e);
      }
    }
    getData(apiUrl) async {
       var fullUrl = _url + apiUrl; 
       return await http.get(
         Uri.parse(fullUrl), 
         headers: _setHeaders()
       );
    }

    _setHeaders() {
      return {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
      };
    }

    _getToken() async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var token = localStorage.getString('token');
        return token;
    }
    showToken()async {
      print(await this._getToken());
    }
}