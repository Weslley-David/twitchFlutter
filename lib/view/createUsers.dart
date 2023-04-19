import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class createUsers extends StatefulWidget {
  const createUsers({super.key});

  @override
  State<createUsers> createState() => _createUsersState();
}

class _createUsersState extends State<createUsers> {
  int _counter = 0;
  int uid = 0;
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();

  List<User> list = [];
  void _incrementCounter() {
    print(_counter);
    setState(() {
      _counter++;
    });
  }

  _openDB() async {
    // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    final database = openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    print('OPENING DATABASE');
    print(database);
    return database;
  }

  Future<void> insertUser(User user) async {
    final db = await _openDB();

    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user);
  }

  Future<List<User>> users() async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query('user');
    list = List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        password: maps[i]['age'],
      );
    });
    return list;
  }

  getUsers() async {
    return '${await users()}';
  }

  // insert() async {
  //   var ruan = const User(
  //     id: 0,
  //     name: 'Ruan Gonzales',
  //     age: 35,
  //   );
  //   await insertUser(ruan);
  // }

  insertUserController(String name, int age) async {
    var user = User(
      id: uid++,
      name: name,
      password: age,
    );
    await insertUser(user);
    getUsers();
  }

  textController() {
    String tempName = name.text;
    int tempAge = int.tryParse(age.text) ?? 1;

    insertUserController(tempName, tempAge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('dayliapp'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 100, height: 100,),
              Image.network(
                  'https://seeklogo.com/images/T/twitch-tv-logo-51C922E0F0-seeklogo.com.png',
                  height: 100,
                  alignment: Alignment.center),
              SizedBox(width: 100, height: 100,),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'name ',
                    labelStyle: TextStyle(color: Colors.purple, fontSize: 15)),
              ),
              TextField(
                  controller: age,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'password',
                      labelStyle: TextStyle(color: Colors.purple, fontSize: 15)),
                  keyboardType: TextInputType.number),
              // const Text(
              //   'You have pushed the button this many times:',
              // ),
              TextButton(
                  onPressed: () => {textController(), setState(() {})},
                  child: const Icon(Icons.keyboard_double_arrow_right_rounded)),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index].name),
                      leading: Text('${list[index].password}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //onPressed: () => {textController(), setState(() {})},
          onPressed: () {
            Navigator.pushNamed(context, '/listusers');
          },
          tooltip: 'Increment',
          child: const Icon(Icons.list),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }
}
