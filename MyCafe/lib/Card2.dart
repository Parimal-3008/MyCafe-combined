
import 'package:flutter/material.dart';

class Card2 extends StatefulWidget {
  late String name;
  late int cost;
  late int index;
  late List<int> quantity;
  late List<int> costarray;
  late List<String> img;
  Card2( {required String name,required int cost,required List<int> quantity,required int index,required List<String> img, required List<int> costarray}){
    this.name=name;
    this.cost = cost;
    this.quantity= quantity;
    this.index = index;
    this.img = img;
    this.costarray = costarray;
      }

  @override
  CCC createState() => CCC();
}

class CCC extends State<Card2> {
  
  // State Object
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: screenWidth*0.4,
      height: screenHeight*0.2,
      decoration: BoxDecoration( 
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.1), //color of shadow
                  spreadRadius: 0, //spread radius
                  blurRadius: 2, // blur radius
                  offset: Offset(0, 2), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
               ),],
               
              ),
      child: Column(
        children: [
          Image.asset(widget.img[widget.index], 
          height: screenHeight*0.12,
          width: screenWidth*0.4,
           
          ),
           Container(
            height: screenHeight*0.04,
            width: screenWidth*0.4,
          
             child: Center(
               child: Text(widget.name,
               textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 200, 87),
                        fontSize: screenHeight * 0.020,
                        fontWeight: FontWeight.bold)),
             ),
          ),
          Container(
            height: screenHeight*0.04,
            width: screenWidth*0.4,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.blue,
            //     width: 1.0,
            //   ),
            // ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(widget.cost.toString()+'/- ',style: TextStyle(fontSize:screenHeight*0.018,color: Color.fromARGB(255,247, 220, 165),fontWeight: FontWeight.bold),),
                  IconButton(icon: Icon(Icons.remove,size: screenHeight*0.023,), onPressed:(){setState(() {if(widget.quantity[widget.index]-1>=0){widget.quantity[widget.index]--;widget.quantity[10]-=widget.costarray[widget.index];}});}, color:Color.fromARGB(255,247, 220, 165)),
              Center(
               child: Text(widget.quantity[widget.index].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize:screenHeight*0.018,color: Color.fromARGB(255,247, 220, 165), fontWeight: FontWeight.bold)),
             ),
               IconButton(icon: Icon(Icons.add, size: screenHeight*0.023,), onPressed: (){setState(() {widget.quantity[widget.index]++;widget.quantity[10]+=widget.costarray[widget.index];});}, color:Color.fromARGB(255,247, 220, 165),),
               
                ],
                
              ),
            ),
           
          )
        ],
      ),
    );


  }}