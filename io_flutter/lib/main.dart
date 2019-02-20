import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

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
  var _sharedPrefsController = new TextEditingController();
  String _savedData = '';

  @override
  void initState() {
    super.initState();
    _readData();
  }

  _readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('my_key') != null &&
          prefs.getString('my_key').isNotEmpty)
        _savedData = prefs.getString('my_key');
      else {
        _savedData = 'No data';
      }
    });
  }

  _writeData(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('my_key', message);
    _readData();
  }

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
                setState(() {});
              },
              child: new Text("Save Data to file"),
            ),
            new Padding(
              padding: new EdgeInsets.all(15),
            ),
            new FutureBuilder(
              future: readData(),
              builder: (BuildContext context, AsyncSnapshot<String> data) {
                if (data.hasData != null) {
                  return new Text('Old Data: ${data.data.toString()}');
                } else {
                  return new Text("File is empty");
                }
              },
            ),
            new TextField(
              controller: _sharedPrefsController,
              decoration: new InputDecoration(labelText: 'Enter Something...'),
            ),
            new IconButton(
              icon: new Icon(Icons.save),
              onPressed: () {
                print(_sharedPrefsController.text);
                _writeData(_sharedPrefsController.text);
                print('Data saved');
              },
            ),
            new Text("SharedPrefs data: $_savedData"),
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
