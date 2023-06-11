import 'package:flutter/material.dart';
import 'package:mycafefrontend/Homepage.dart';
import 'package:mycafefrontend/Menu.dart';
import 'package:mycafefrontend/PendingOrders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'MyOrders.dart';

class MainPage extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  @override
  void initState()
  {
    super.initState();
    print('init');
    fetchbalance();

  }
  String selected = "Menu";
  String balance ='-'; 
  bool loading = true; 
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
        appBar: AppBar(
          toolbarHeight:screenHeight*0.06 ,
            backgroundColor: Color.fromARGB(255, 44, 38, 59),
            // title: loading?CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 200, 87)),):Text('Balance: ' + balance.toString())),
        title: Text('Balance: ' + balance.toString())),
        body: Container( 
          color: Color.fromARGB(255, 44, 38, 59),
          child:loading?  Dialog(
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
          ):selected=='Menu'?Menu():selected=='Orders'?MyOrders():selected=='Current Orders'?PendingOrders():Menu()
          ),
            drawer: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: Drawer(
            child: Container(
              color: Color.fromARGB(255, 44, 38, 59),
              child: ListView(
                 padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 44, 38, 59),
                      ),
                      child: Text(
                        '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 200, 87)),
                        textAlign: TextAlign.center,
                      )),
                  ListTile(
                    title: const Text(
                      'Menu',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 200, 87),
                          fontSize: 20),
                    ),
                    onTap: () {
                      setState(() {
                        selected = "Menu";
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Current Orders',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 200, 87),
                            fontSize: 20)),
                    onTap: () {
                      setState(() {
                        selected = "Current Orders";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('My Orders',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 200, 87),
                            fontSize: 20)),
                    onTap: () {
                      setState(() {
                        selected = "Orders";
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders()));
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Logout',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 200, 87),
                            fontSize: 20)),
                    onTap: () {
                      setState(() {
                        logout();
                        
                      });
                      Navigator.pop(context);
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
  Future<Widget> fetchbalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
  var url = Uri.parse('https://mycafe-backend.onrender.com/getbalance?username='+ prefs.getString('currentuser').toString());
  try {
    var response = await http.get(url);
    
    if (response.statusCode == 200) {
      // Successful GET request
      print(response.body); // Print response body
      setState(() {
        print("response");
        loading = false;
        // Navigator.of(context).pop();
              balance = (response.body).toString();
            });
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions
    print('Exception: $e');
  }
  return Text('');
}

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currentuser', '');
    
  }
  
}
