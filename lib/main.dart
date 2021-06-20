import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String infoText = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                          decoration: InputDecoration(labelText: 'メールアドレス'),
                          onChanged: (String value) {
                            setState(() {
                              email = value;
                            });
                          }),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'パスワード'),
                          onChanged: (String value) {
                            setState(() {
                              password = value;
                            });
                          }),
                      Container(
                          padding: EdgeInsets.all(8), child: Text(infoText)),
                      Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              child: Text('ユーザー登録'),
                              onPressed: () async {
                                try {
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  final result =
                                      await auth.createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                    return TodoListPage(result.user!);
                                  }));
                                } catch (e) {
                                  setState(() {
                                    infoText = '登録に失敗しました : ${e.toString()}';
                                  });
                                }
                              })),
                      const SizedBox(height: 8),
                      Container(
                          width: double.infinity,
                          child: OutlinedButton(
                              child: Text('ログイン'),
                              onPressed: () async {
                                try {
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  final result =
                                      await auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                    return TodoListPage(result.user!);
                                  }));
                                } catch (e) {
                                  setState(() {
                                    infoText = 'ログインに失敗しました : ${e.toString()}';
                                  });
                                }
                              }))
                    ]))));
  }
}

class TodoListPage extends StatefulWidget {
  final User user;
  TodoListPage(this.user);

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
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
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
