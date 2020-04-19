import 'package:aarvi_textiles/Screens/DashboardMang/workerlist.dart';
import 'package:flutter/material.dart';

class WorkerMang extends StatefulWidget {
  @override
  _WorkerMangState createState() => _WorkerMangState();
}

class _WorkerMangState extends State<WorkerMang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Operator Mangement'),
        backgroundColor: Colors.cyan,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.track_changes),
            onPressed: () {},
          ),
        ],
      ),
      // body: WorkerList(),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        child: Icon(Icons.person_add),
        onPressed: () {
           Navigator.pushNamed(context, '/addworker');
        },
      ),
    );
  }
}