import 'package:flutter/material.dart';
import 'package:mycafefrontend/MainPage.dart';


AlertDialog alert(BuildContext context, String msg,String title, String status) { return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: TextStyle(
              color: Color.fromARGB(255, 255, 200, 87),
              fontWeight: FontWeight.bold),
        ),
        content: Text(msg,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 200, 87),
            )),
        actions: [
           TextButton(
    child: Text("OK",style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)),),
    onPressed: () {
      if(status =='gotomenu')
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
      else
      Navigator.of(context).pop();
    },
  ),
        ],
      );}