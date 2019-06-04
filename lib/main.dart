import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getJSON();
  List _features = _data['features'];

  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        title: Text("Quake App"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(14.2),
          itemBuilder: (BuildContext context, int position) {
            final index = position ~/ 2;
            var format = new DateFormat.yMMMd("en_US").add_jm();
            var date = format.format(new DateTime.fromMillisecondsSinceEpoch(
                _features[index]['properties']['time']));
//            var format = DateTime("yMd");
//            var date = format.format(new DateTime.fromMillisecondsSinceEpoch(_features[index]['properties']['time']));

            return Column(
              children: <Widget>[
                Divider(
                  height: 10.5,
                ),
                ListTile(
                  title: Text(
                    date.toString(),
                    style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 24.5,
                        fontWeight: FontWeight.w200),
                  ),
                  subtitle: Text(
                    _features[position]['properties']['place'].toString(),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      _features[position]['properties']['mag'].toString(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                  onTap: () => somethingontap(
                      context, _features[position]['properties']['title']),
                )
              ],
            );
          }),
    ),
  ));
}

void somethingontap(BuildContext context, String message) {
  var alertbox = new AlertDialog(
    title: Text('Quake', style: TextStyle(fontSize: 14.0)),
    content: Text(message),
    actions: <Widget>[
      FlatButton(onPressed: () => Navigator.pop(context), child: Text("done"))
    ],
  );
  showDialog(
      context: context,
      builder: (context) {
        return alertbox;
      });
}

Future<Map> getJSON() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}
