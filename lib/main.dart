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
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          ElevatedButton(
              child: Text('ログイン'),
              onPressed: () async {
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return TodoListPage();
                }));
              })
        ])));
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<String> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('リスト一覧'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            await Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          },
        ),
      ]),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return Card(child: ListTile(title: Text(todoList[index])));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TodoAddPage();
            }),
          );
          if (newListText != null) {
            setState(() {
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('リスト追加')),
        body: Container(
            padding: EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_text, style: TextStyle(color: Colors.blue)),
                const SizedBox(height: 8),
                TextField(onChanged: (String value) {
                  setState(() {
                    _text = value;
                  });
                }),
                const SizedBox(height: 8),
                Container(
                    width: double.infinity, // 横幅いっぱい
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(_text);
                        },
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
