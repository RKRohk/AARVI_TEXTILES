import 'package:aarvi_textiles/Screens/ProductionMang/IEManagement/MachineReq.dart';
import 'package:flutter/material.dart';

class IEmanage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IE Management"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text("Operation Bulletin"),
              onPressed: () => {},
            ),
            RaisedButton(
              child: Text("Time Study"),
              onPressed: (){},
            ),
            RaisedButton(
              child: Text("Machine Requirement(Style Wise)"),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => MachineReq(),));
              },
            ),
          ],
        ),
      ),
    );
  }
}