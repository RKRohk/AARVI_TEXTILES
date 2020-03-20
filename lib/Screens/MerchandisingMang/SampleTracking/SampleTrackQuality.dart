import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SampleTrackQuality extends StatefulWidget {
  @override
  _SampleTrackQualityState createState() => _SampleTrackQualityState();
}

class _SampleTrackQualityState extends State<SampleTrackQuality> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final styleNo = TextEditingController();
  final buyer = TextEditingController();
  final sampleType = TextEditingController();
  final totalPiecesChecked = TextEditingController();
  final totalDefecit = TextEditingController();
  final totalRework = TextEditingController();
  final totalRejected = TextEditingController();
  final inputDec = InputDecoration(
    labelText: "Style No",
    fillColor: Colors.white,
    filled: true,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown, width: 2)),
  );
  String dropdownvalue = 'Proto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text("Aarvi Textiles"),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Sample Tracking - Quality",
                  style: TextStyle(color: Colors.brown, fontSize: 20),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: styleNo,
                  onChanged: (value) async {
                    await Firestore.instance
                        .collection('aarvi')
                        .document(styleNo.value.text)
                        .get()
                        .then((value) {
                      if (value.exists) {
                        var data = value.data;
                        buyer.text = data['buyer'];
                        dropdownvalue = data['sample_type'] ?? 'Fit';
                        totalPiecesChecked.text =
                            data['sample_track_checked'] ?? '';
                        totalDefecit.text = data['sample_track_defecit'] ?? '';
                        totalRework.text = data['sample_track_rework'] ?? '';
                        totalRejected.text =
                            data['sample_track_rejected'] ?? '';
                      } else
                        print("NOTGOT");
                    });
                    setState(() {
                      print("Got");
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Style No",
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown, width: 2)),
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: buyer,
                  decoration: inputDec.copyWith(labelText: "Buyer"),
                ),
                SizedBox(height: 10),
                Text("Sample Type"),
                DropdownButton<String>(
                  value: dropdownvalue,
                  icon: Icon(Icons.arrow_downward),
                  items: <String>[
                    'Proto',
                    'Fit',
                    'Salesman',
                    'Size Set',
                    'Pre Production',
                    'Shipment'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownvalue = newValue;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: totalPiecesChecked,
                  keyboardType: TextInputType.number,
                  decoration:
                      inputDec.copyWith(labelText: "Total Pieces Checked"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: totalDefecit,
                  keyboardType: TextInputType.number,
                  decoration: inputDec.copyWith(labelText: "Total Defecit"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: totalRework,
                  keyboardType: TextInputType.number,
                  decoration: inputDec.copyWith(labelText: "Total Rework"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: totalRejected,
                  keyboardType: TextInputType.number,
                  decoration: inputDec.copyWith(labelText: "Total Rejected"),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    scaffoldState.currentState.showSnackBar(SnackBar(
                      content: Text("Uploading"),
                    ));
                    try {
                      await Firestore.instance
                          .collection('aarvi')
                          .document(styleNo.value.text)
                          .updateData({
                        'sample_type': dropdownvalue,
                        'sample_track_checked': totalPiecesChecked.value.text,
                        'sample_track_defecit': totalDefecit.value.text,
                        'sample_track_rework': totalRework.value.text,
                        'sample_track_rejected': totalRejected.value.text
                      });
                      scaffoldState.currentState.showSnackBar(SnackBar(
                        content: Text("Done"),
                      ));
                    } catch (e) {
                      scaffoldState.currentState.showSnackBar(SnackBar(
                        content: Text(e.toString()),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
