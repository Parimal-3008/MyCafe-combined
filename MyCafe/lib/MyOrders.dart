import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyOrders extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyOrders> {
  var data={};
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
        child: Text('My Orders',textAlign: TextAlign.center,style: TextStyle(color:Color.fromARGB(255, 255, 200, 87),fontSize: 30, fontWeight: FontWeight.bold ),),
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
   var url = Uri.parse('https://mycafe-backend.onrender.com/getdata?username='+ prefs.getString('currentuser').toString());
  try {
    var response = await http.get(url); 
    
    if (response.statusCode == 200) {
      // Successful GET request
      print(response.body); // Print response body
      setState(() {
              data= json.decode(response.body);
              data= data['data'];
              loading = false;
            });
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions
    print('Exception: $e');
  }
}

List<DataRow> _createRows() {
  List<DataRow> list = [];
   for(int i = 0; i< data["id"].length;i++)
   {
    list.add(DataRow(cells: [
      DataCell(Text(data["time"][i])),
      DataCell(Text(data["id"][i].toString())),
      DataCell(Text(data["order"][i])),
     
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
