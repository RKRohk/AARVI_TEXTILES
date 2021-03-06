import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:aarvi_textiles/services/textfieldBox.dart';

class SewingHourlyProduction extends StatefulWidget {
  @override
  _SewingHourlyProductionState createState() => _SewingHourlyProductionState();
}
var controllers = <TextEditingController>[];
var rowList = List<DataRow>();

SizedBox leaveSpace() {
  return SizedBox(
    height: 10,
  );
}
DataRow getRow(int index,{bool newController = true}) {
  var list = List<DataCell>();
  index = index * 11;
  for (int i = index; i < index + 11; ++i) {
    newController ? controllers.add(TextEditingController()) : print("Not New Controller");
    list.add(DataCell(TextField(
      controller: controllers[i],
    )));
  }
  return DataRow(cells: list);
}

class _SewingHourlyProductionState extends State<SewingHourlyProduction> {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  int rows = 0;
  TextEditingController lineNo = TextEditingController(),
      operatorName = TextEditingController(),
      operationName = TextEditingController(),
      first = TextEditingController(),
      second = TextEditingController(),
      third = TextEditingController(),
      fourth = TextEditingController(),
      fifth = TextEditingController(),
      sixth = TextEditingController(),
      seventh = TextEditingController(),
      eigth = TextEditingController(),
      date = TextEditingController();
    
    List<DataRow> getRows() {
    for (int i = 0; i < rows; ++i) rowList.add(getRow(i));
    return rowList;
    }

  @override
  void initState() {
    rows = 0;
    controllers = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(title: Text('Hourly Production report')),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextFormField(
                  decoration: TextFieldDec.inputDec("Line Number"),
                  controller: lineNo
                ),
              leaveSpace(),
              DateTimeField(
                  controller: date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: TextFieldDec.inputDec("Date"),
                    onShowPicker: (context, currentValue) async {
                      final dat = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2100));
                      try{
                        await Firestore.instance.collection('lines').document(lineNo.value.text).collection('HourlyProduction').document(DateFormat('dd-MM-yyyy').format(dat)).get().then((value) {
                          if(value.exists){
                            var data = value;
                            int len = 0;
                            data['table'].forEach((element) {
                              len++;
                            });
                            for(int i=0; i<len;i = i + 11){
                              for(int j=i;j<i+11;++j){
                                controllers.add(TextEditingController());
                                controllers[j].text = data['table'][j];
                                print(controllers[j].text);
                              }
                              rowList.add(getRow(rows++,newController: false));
                            }
                          }
                        });
                      }
                      catch(e){
                        _scaffoldState.currentState.showSnackBar(SnackBar(content: Text(e.toString()),));
                      }
                      setState(() {

                      });
                      return dat;
                    }),
              leaveSpace(),
              Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text("Operation",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                                label: Text("Operator",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Style No",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("1ST HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("2ND HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("3RD HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("4TH HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("5TH HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("6TH HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("7TH HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("8TH HOUR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)))
                          ],
                          rows: rowList,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          color: Colors.blueAccent,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              print("Rows = " + rows.toString());
                              rowList.add(getRow(rows++));
                              print(controllers.length);
                            });
                          },
                        ),
                        IconButton(
                          color: Colors.redAccent,
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              print(controllers.length);
                              rows--;
                              if(rows>=0){
                                rowList.removeLast();
                                [1,2,3,4,5,6,7,8,9,10,11].forEach((element) {
                                  controllers.removeLast();
                                });
                              }
                              else{
                                rows = 0;
                              }
                            });
                          },
                        ),
                        IconButton(
                          color: Colors.green,
                          icon: Icon(Icons.refresh),
                          onPressed: (){
                            setState(() {
                              controllers = [];
                              rows = 0;
                              rowList = [];
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
                RaisedButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Uploading"),));
                    try{
                      var tableList = [];
                      controllers.forEach((element) {
                        tableList.add(element.value.text);
                      });
                      await Firestore.instance.collection('lines').document(lineNo.value.text).collection('HourlyProduction').document(date.value.text).
                      setData({
                        'table':tableList
                      });
                    }
                    catch(e){
                      _scaffoldState.currentState.showSnackBar(SnackBar(content: Text(e.toString()),));
                    }
                    controllers.forEach((element) {print(element.value.text);});
                    _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Done"),));

                  },
                )
            ],
          )
        ),
      ),
    );
  }   
}

