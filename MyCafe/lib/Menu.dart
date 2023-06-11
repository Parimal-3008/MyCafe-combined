// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import  'package:intl/intl.dart';

import 'Card2.dart';
import 'alert.dart';

class Menu extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Menu> {
  var images = [
    "assets/vadapav.jpg", 
    "assets/vegsandwich.jpg",
    "assets/masaladosa.jpg",  
    "assets/breadbutter.jpg",
    "assets/manchurian.jpg",
    "assets/noodles.jpg",
    "assets/uttapam.jpg",
    "assets/samosa.jpg",
    "assets/breadpakoda.jpg",
    "assets/ragdapattice.jpg"
  ];
  var itemsname = [
    "Vada pav",
    "Veg Sandwich",
    "Masala Dosa",
    "Bread Butter",
    "Manchurian",
    "Noodles",
    "Uttapam",
    "Samosa",
    "Bread Pakoda",
    "Ragda Pattice"
  ];
  var itemcost = [10, 20, 40, 25, 30, 40, 20, 15, 20, 40];
  var quantity = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  late String order;

  // State Object
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: 5),
          child: Container(
            width: screenWidth * 1.0,
            height: screenHeight * 0.85,
            // color: Color.fromARGB(255, 44, 38, 59),

            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < 10; i += 2)
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card2(
                              name: itemsname[i],
                              cost: itemcost[i],
                              quantity: quantity,
                              costarray:itemcost,
                              img: images,
                              index: i),
                          Card2(
                              name: itemsname[i + 1],
                              cost: itemcost[i + 1],
                              quantity: quantity,
                              costarray:itemcost,
                              img: images,
                              index: i + 1),
                        ],
                      ),
                    ),
                ],
              )
            ]),
          ),
        ),
        Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.08,
            // color: Color.fromARGB(0, 40, 38, 59),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 60, 58, 79),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Adjust the border radius as needed
                    // Adjust the border color as needed
                  ),
                ),
              ),
              onPressed: () {
                showAlertDialog(context, itemcost, itemsname, quantity);
              },
              child: Text('Order Now',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 200, 87),
                      fontSize: screenHeight * 0.035,
                      fontWeight: FontWeight.bold)),
            ))
      ],
    );
  }

  


showAlertDialog(BuildContext context, List<int> itemcost,
    List<String> itemsname, List<int> quantity) {
  // set up the buttons

  Widget cancelButton = TextButton(
    child: Text("Cancel",
        style: TextStyle(color: Color.fromARGB(255, 255, 200, 87))),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget placebutton = TextButton(
    child: Text(
      "Place Order",
      style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)),
    ),
    onPressed: () {
      // CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 200, 87)));
      String str="";
      for(int i=0;i<10;i++)
      {
        if(quantity[i]>0)
        str= str +  itemsname[i].toString()+ '(x' + quantity[i].toString()+'), ';
        if(i==9)
        setState(() {order = str;});
      }
    if(quantity[10]<=0)
      {
        Navigator.of(context).pop();
        showDialog(context: context,builder: (BuildContext context) {return alert(context,'Please order something','','');});
      }
      else
      {
        Navigator.of(context).pop();
        updatebalance(quantity);
      }
    },
  );
  // set up the AlertDialog
  AlertDialog alert2 = AlertDialog(
    title: Text(
      "Confirm Order",
      style: TextStyle(
          color: Color.fromARGB(255, 255, 200, 87),
          fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.black,
    content: _createDataTable(itemsname, itemcost, quantity),
    actions: [cancelButton, placebutton],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert2;
    },
  );
}

Future<Widget> updatebalance(List<int> quantity) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
    var url = Uri.parse('https://mycafe-backend.onrender.com/updatebalance');
  var url2 = Uri.parse(' https://mycafe-backend.onrender.com/adddata');
  final databaseRef = FirebaseDatabase.instance.ref(prefs.getString('currentuser'));
  var headers = {
    'Content-Type': 'application/json',
    // Add any other headers as needed
  };
  
  var body = {
    'username': prefs.getString('currentuser'),
    'cost': quantity[10],
    'operation':'-',
  };  
  var body2 = {
    'username': prefs.getString('currentuser'),
    'id': "145236",
    'date_time': (DateFormat("dd-MM-yyyy").format(DateTime.now()).toString()+' '+DateFormat("HH:mm").format(DateTime.now()).toString()).toString(),
     'order':order,
     
  };  
  databaseRef.push().set(body2);
  
  var response = await http.post(url, headers: headers, body: jsonEncode(body));  
  // var response2 = await http.post(url2, headers: headers, body: jsonEncode(body2));  
  if (response.statusCode == 200){
    //  && response2.statusCode == 200) {
      print(body2);
      Navigator.of(context).pop(); 
      showDialog(context: context,builder: (BuildContext context) {return alert(context, 'Your Order id:', 'Order Placed','gotomenu');});
       setState(() {
            for(int i=0;i<=10;i++)
            quantity[i] = 0;
          });
         
  // Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));

          
  }
 return Text('');
}

DataTable _createDataTable(
    List<String> itemsname, List<int> itemcost, List<int> quantity) {
  return DataTable(
    columns: _createColumns(),
    rows: _createRows(itemsname, itemcost, quantity),
    dividerThickness: 0,
    dataRowHeight: 25,
    columnSpacing: 10,
    headingRowHeight: 30,
    showBottomBorder: true,
    headingTextStyle:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    headingRowColor:
        MaterialStateProperty.resolveWith((states) => Colors.black),
    dataTextStyle: TextStyle(color: Colors.grey),
  );
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(
        label: Text('Name(Price)',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)))),
    DataColumn(
        label: Text('Quantity',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)))),
    DataColumn(
        label: Text('Cost',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)))),
  ];
}

List<DataRow> _createRows(
    List<String> itemsname, List<int> itemcost, List<int> quantity) {
  List<DataRow> list = [];
  int sum = 0;
  int netquantity = 0;
  for (var i = 0; i < 10; i++) {
    if (quantity[i] != 0)
      list.add(DataRow(cells: [
        DataCell(Text(
          itemsname[i] + '(' + itemcost[i].toString() + ')',
          style: TextStyle(fontSize: 10),
        )),
        DataCell(Text(
          quantity[i].toString(),
          style: TextStyle(
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        )),
        DataCell(Text((quantity[i] * itemcost[i]).toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))
      ]));
    sum += quantity[i] * itemcost[i];
    netquantity += quantity[i];
  }
  list.add(DataRow(cells: [
    DataCell(Text(
      'Total:',
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    )),
    DataCell(Text(
      netquantity.toString(),
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    )),
    DataCell(Text(sum.toString(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))
  ]));

  return list;
}
}