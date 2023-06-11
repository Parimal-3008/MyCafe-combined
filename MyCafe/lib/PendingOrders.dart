// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PendingOrders extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PendingOrders> {
   var data=[];
  bool loading = true;
  @override
  void initState()
  {
    super.initState();
    print('init');
    getuserdata();
  }
  // State Object
  @override
  Widget build(BuildContext context) {

    return 
    loading?  Dialog(
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
          ):
    ListView(
      children: [Padding(
        padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
        child: Text('Pending Orders',textAlign: TextAlign.center,style: TextStyle(color:Color.fromARGB(255, 255, 200, 87),fontSize: 30, fontWeight: FontWeight.bold ),),
      ),
       DataTable(
    columns: _createColumns(),
    rows: _createRows(),
    dividerThickness: 1,
    dataRowHeight: 55,
    columnSpacing: 10,
    headingRowHeight: 50,
    showBottomBorder: true,
    headingTextStyle:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    headingRowColor:
        MaterialStateProperty.resolveWith((states) => Colors.black),
    dataTextStyle: TextStyle(color: Colors.grey),
       )
      ],
      );
  }

  Future<void> getuserdata() async {
SharedPreferences prefs = await SharedPreferences.getInstance();
final databaseRef = FirebaseDatabase.instance.ref(prefs.getString('currentuser').toString());
Stream<DatabaseEvent> stream = databaseRef.onValue;

// Subscribe to the stream!
stream.listen((DatabaseEvent event) {
  setState(() {
    loading = false;
    if(event.snapshot.value != null)
    data = (event.snapshot.value as Map).values.toList();
    else
    data=[];
    
 
  });
  
});
  //  var url = Uri.parse('https://mycafe-backend.onrender.com/getdata?username='+ prefs.getString('currentuser').toString());
}

List<DataRow> _createRows() {
  List<DataRow> list = [];
  // print(data);
   for(int i = 0; i< data.length;i++)
   {
    list.add(DataRow(cells: [
      DataCell(Text(data[i]["date_time"])),
      DataCell(Text(data[i]["id"].toString())),
      DataCell(Text(data[i]["order"])),
     
      ]));

   }

  return list;
}


}
List<DataColumn> _createColumns() {
  return [
    DataColumn(
        label: Text('Date/Time',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)))),
    DataColumn(
        label: Text('ID',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)))),
    DataColumn(
        label: Text('Order',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 87)))),
    
            
  ];
}
