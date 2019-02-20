import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main(List<String> args) {
  runApp(MaterialApp(
    home: IOFlutter(),
  ));
}

class IOFlutter extends StatefulWidget {
  @override
  _IOFlutterState createState() => _IOFlutterState();
}

class _IOFlutterState extends State<IOFlutter> {
  var _enterDataField = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('File IO'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: new Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            new ListTile(
              title: new TextField(
                controller: _enterDataField,
                decoration: new InputDecoration(
                  labelText: 'Write something...',
                ),
              ),
            ),
            new FlatButton(
              onPressed: () {
                String text = _enterDataField.text;
                if (text.isNotEmpty) writeData(text);
              },
              child: new Text("Save Data to file"),
            ),
            new Padding(
              padding: new EdgeInsets.all(15),
            ),
            new FutureBuilder(
              future: readData(),
              builder: (BuildContext context, AsyncSnapshot<String> data) {
                if(data.hasData != null){
                  return new Text('Old Data: ${data.data.toString()}');
                } else{
                  return new Text("File is empty");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/myFile.txt');
}

Future<File> writeData(String message) async {
  final file = await _localFile;

  return file.writeAsString(message);
}

Future<String> readData() async {
  try {
    final file = await _localFile;

    String data = await file.readAsString();
    return data;
  } catch (e) {
    return "Nothing is saved in the file!";
  }
}
