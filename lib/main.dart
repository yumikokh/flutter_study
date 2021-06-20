import 'package:flutter/material.dart';

void main() {
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト一覧'),
      ),
      body: ListView(children: <Widget>[
        Card(child: ListTile(title: Text('やっほー1'))),
        Card(child: ListTile(title: Text('やっほー2'))),
        Card(child: ListTile(title: Text('やっほー3'))),
        Card(child: ListTile(title: Text('やっほー4'))),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TodoAddPage();
            }),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('リスト追加')),
        body: Container(
            padding: EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(),
                const SizedBox(height: 8),
                Container(
                    width: double.infinity, // 横幅いっぱい
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text('リスト追加',
                            style: TextStyle(color: Colors.white)))),
                const SizedBox(height: 8),
                Container(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('キャンセル')))
              ],
            )));
  }
}
