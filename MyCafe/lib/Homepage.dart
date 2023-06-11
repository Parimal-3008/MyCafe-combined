import 'package:flutter/material.dart';

import 'LoginCustomer.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
          color: Color.fromARGB(255, 44, 38, 59),
          child: Center(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 250, 0, 250),
          child: Container(
              height: screenHeight * 0.3,
              width: screenWidth * 0.75,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.black,
              //     width: 1.0,
              //   ),
              // ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: Container(
                      width: screenWidth * 0.75,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCustomer()));},
                        child: Text('Sign in as customer'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 242, 200, 87)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Color.fromARGB(255, 44, 38, 59)),
                        ),
                      ),
                    ),
                  ),
                 
                ],
              )),
      ),
    ),
        ));
  }
}
