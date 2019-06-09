import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lyra',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.yellow,
      ),
      home: new MyHomePage(title: 'Lyra Poetry'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> poems = [];

  void _loadPoems() async {
    poems = [];
    final response = await http.get('https://raw.githubusercontent.com/Lyrenhex/lyrenhex.github.io/master/poetry.json');
    Map data = json.decode(response.body);
    final ps = (data['poems'] as List).map((i) => new Poem.fromJson(i));
    setState(() {
      for (final p in ps) {
        poems.add(poem(p.title, p.description, p.content));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    _loadPoems();
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new ListView(
          padding: const EdgeInsets.all(20.0),
          reverse: true,
          children: poems,
        )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _loadPoems,
        tooltip: 'Reload',
        child: new Icon(Icons.refresh),
      ),
    );
  }

  Widget poem(String title, String description, String content) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(title),
            subtitle: new Text(description),
            onTap: () { _viewPoem(title, content); },
          ),
        ],
      ),
    );
  }

  _viewPoem(String title, String content) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {          
          return new Scaffold(
            appBar: new AppBar(
              title: new Text(title + ", by Damian Heaton."),
            ),
            body: new ListView(
              padding: new EdgeInsets.all(20.0),
              children: <Widget>[
                new ListTile(
                  title: new Text(title, textScaleFactor: 2.0),
                  subtitle: new Text(content, textScaleFactor: 1.25),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Poem {
  String title;
  String description;
  String content;

  Poem.fromJson(Map json) {
    this.title = json['title'];
    this.description = json['description'];
    this.content = json['content'];
  }
}