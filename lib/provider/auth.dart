import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping/models/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userid;
  DateTime _dateTime;
  Timer _authtimer;

  bool get isauth {
    return token != null;
  }

  String get token {
    if (_dateTime != null &&
        _dateTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userid {
    return _userid;
  }

  Future<void> signup(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBkxgx1FajWebsJlo8nqpyPrWWUU8iLM_s';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _userid = data['localId'];
      _dateTime = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // return _authonticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBkxgx1FajWebsJlo8nqpyPrWWUU8iLM_s';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _userid = data['localId'];
      _dateTime = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      autologout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userId': _userid,
        'expiryDate': _dateTime.toIso8601String(),
      });
      prefs.setString('userdata', userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout()async {
    _token = null;
    _userid = null;
    _dateTime = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autologout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final time = _dateTime.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: time), logout);

  }

  Future<bool> autologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final extractuserdata =
        json.decode(prefs.getString('userdata')) as Map<String, Object>;
    final expirydate = DateTime.parse(extractuserdata['expiryDate']);
    if (expirydate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractuserdata['token'];
    _userid = extractuserdata['userId'];
    _dateTime = expirydate;
    notifyListeners();
    autologout();
    return true;
  }
}
