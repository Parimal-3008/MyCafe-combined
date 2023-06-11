import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mycafefrontend/MainPage.dart';
import 'package:mycafefrontend/alert.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginCustomer extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginCustomer> {
  // State Object
  Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'password': TextEditingController(),
    'password2': TextEditingController(),
  };
  bool login = true;
  bool loading = false;
  String currentuser = '';
  Color color1 = Color.fromARGB(255, 255, 200, 87);
  Color color2 = Color.fromARGB(255, 44, 38, 59);
  Color color3 = Color.fromARGB(255, 255, 200, 87);
  Color color4 = Color.fromARGB(255, 44, 38, 59);
  bool _isObscure = true;
  String generateHash(String password) {
  var bytes = utf8.encode(password); // Convert password string to bytes
  var hash = sha256.convert(bytes); // Generate SHA-256 hash
  return hash.toString(); // Return the hashed value as a string
}
  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentuser = prefs.getString('currentuser').toString();
    });
  }
  @override
  void initState() {
    super.initState();
    loadCounter();
  }
  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 44, 38, 59),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              height: screenHeight * 0.75,
              width: screenWidth * 0.8,
              // decoration: BoxDecoration(
              //    border: Border.all(
              //      color: Colors.white,
              //      width: 0.0,
              //    ),
              // ),
              child: ListView(children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                      child: Container(
                        width: screenWidth * 0.75,
                        height: 70,
                        // color: Colors.black,
                        child: Row(
                          children: [
                            Container(
                                height: screenHeight * 0.2,
                                width: screenWidth * 0.375,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      login = true;
                                      color1 =
                                          Color.fromARGB(255, 255, 200, 87);
                                      color2 = Color.fromARGB(255, 44, 38, 59);
                                      color3 =
                                          Color.fromARGB(255, 255, 200, 87);
                                      color4 = Color.fromARGB(255, 44, 38, 59);
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            color1), // Background color
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            color2),
                                  ),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: screenHeight / 30,
                                      fontWeight: FontWeight.bold,
                                      // color: color3,
                                    ),
                                  ),
                                )),
                            Container(
                                height: screenHeight * 0.2,
                                width: screenWidth * 0.375,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      login = false;
                                      color2 =
                                          Color.fromARGB(255, 255, 200, 87);
                                      color1 = Color.fromARGB(255, 44, 38, 59);
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            color2), // Background color
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            color1), // Text color
                                    // You can also set other properties like padding, shape, etc. here
                                  ),
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontSize: screenHeight / 30,
                                      fontWeight: FontWeight.bold,
                                      // color: color3,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: _controllers['username'],
                        style:
                            TextStyle(color: Color.fromARGB(255, 255, 200, 87)),
                        textAlign: TextAlign.center,
                        cursorColor: Color.fromARGB(255, 78, 86, 110),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 78, 86, 110)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 78, 86, 110),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50.0)),
                          fillColor: Color.fromARGB(255, 78, 86, 110),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 78, 86, 110),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50.0)),
                          hintText: 'USERNAME',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: _controllers['password'],
                        style:
                            TextStyle(color: Color.fromARGB(255, 255, 200, 87)),
                        textAlign: TextAlign.center,
                        obscureText: _isObscure,
                        cursorColor: Color.fromARGB(255, 78, 86, 110),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              color: Color.fromARGB(255, 78, 86, 110),
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 78, 86, 110)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 78, 86, 110),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50.0)),
                          fillColor: Color.fromARGB(255, 78, 86, 110),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 78, 86, 110),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(50.0)),
                          hintText: 'PASSWORD',
                        ),
                      ),
                    ),
                    if (!login)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          controller: _controllers['password2'],
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 200, 87)),
                          textAlign: TextAlign.center,
                          obscureText: _isObscure,
                          cursorColor: Color.fromARGB(255, 78, 86, 110),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                color: Color.fromARGB(255, 78, 86, 110),
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 78, 86, 110)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 78, 86, 110),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(50.0)),
                            fillColor: Color.fromARGB(255, 78, 86, 110),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 78, 86, 110),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(50.0)),
                            hintText: 'CONFIRM PASSWORD',
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                      child: Container(
                        width: screenWidth * 0.75,
                        height: 70,
                        child: TextButton(
                          onPressed: handlelogin,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(
                                    255, 255, 200, 87)), // Background color
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 44, 38, 59)),
                          ),
                          child: Text(
                            login ? 'LOGIN' : 'SIGN UP',
                            style: TextStyle(
                              fontSize: screenHeight / 30,
                              fontWeight: FontWeight.bold,
                              // color: color3,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  
  
  Widget handlelogin() {
    setState(() {
          loading = true;
        });
    String username = _controllers['username']!.text.trim();
    String password = _controllers['password']!.text.trim();
    String password2 = _controllers['password2']!.text.trim();
    if(username.trim().length == 0 || password.trim().length == 0 )
       showDialog(context: context,builder: (BuildContext context) {return alert(context,'Username/Password cannot be null','','');});
    else if (!login && password2 != password) 
      showDialog(context: context,builder: (BuildContext context) {return alert(context,'Passwords does not match','','');});
    else
        {
          if(loading)
          showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            // The background color
            backgroundColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 200, 87)),),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...',style: TextStyle(color:Color.fromARGB(255, 255, 200, 87)),)
                ],
              ),
            ),
          );
        });
          checklogin(username,generateHash(password),context);
          
        }
        return Text('');
  }

  Future<Widget> checklogin(String username, String password, BuildContext context2) async {
  var url = Uri.parse('https://mycafe-backend.onrender.com/'+(login?'login':'register'));
  
  var headers = {
    'Content-Type': 'application/json',
    // Add any other headers as needed
  };
  
  var body = {
    'username': username,
    'password': password,
  };  
  var response = await http.post(url, headers: headers, body: jsonEncode(body));  
  if (response.statusCode == 200) {
    // Request successful, parse the response
    
    if(login)
    print('login successfull');
    else
    print('registration successfull');
    setState(() {
          loading = false;          
        });
        SharedPreferences preferences= await SharedPreferences.getInstance();
        preferences.setString('currentuser', username);
     Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
  } 
   else {
    // Request failed
    print('login failed');
     setState(() {
          loading = false;
        });
        Navigator.of(context2).pop();
    showDialog(context: context,builder: (BuildContext context) {return alert(context,response.statusCode==400?'Use other username':'Invalid credentials','Unauthorized','');});
    
  }
  return Text('');
}
}
