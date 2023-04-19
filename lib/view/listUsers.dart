import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class listUsers extends StatefulWidget {
  const listUsers({super.key});

  @override
  State<listUsers> createState() => _listUsersState();
}

class _listUsersState extends State<listUsers> {
  List<User> list = [];

  //Future<List<User>>
  users() async {
    _openDB() async {
      WidgetsFlutterBinding.ensureInitialized();
      final database = openDatabase(
        join(await getDatabasesPath(), 'users.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, age INTEGER);',
          );
        },
        version: 1,
      );
      print('DATABASE OPENNG');
      print(database);
      return database;
    }

    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query('user');
    list = List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        password: maps[i]['age'],
      );
    });
    // return list;
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('List of users'),
    //     actions: [
    //       IconButton(onPressed: () {users(

    //       );}, icon: const Icon(Icons.refresh))
    //     ],
    //   ),
    //   body:
    //   Column(children: [
    //     Expanded(
    //       child: ListView.builder(
    //         itemCount: list.length,
    //         itemBuilder: (context, index) {
    //           return ListTile(
    //             title: Text(list[index].name),
    //             leading: Text('${list[index].name}'),
    //           );
    //         },
    //       ),
    //     ),
    //   ]),
    // );
    return FutureBuilder(
      // Waiting your async function to finish
      future: users(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // To access the function data when is done
          // you can take it from **snapshot.data**
          return Scaffold(
            appBar: AppBar(
              title: Text('List of users'),
              actions: [
                IconButton(
                    onPressed: () {
                      users();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${list[index].password}'),
                      leading: Text(list[index].name),
                    );
                  },
                ),
              ),
            ]),
          );
        } else {
          // Show loading during the async function finish to process
          return const Scaffold(
            body: Text('No data'),
          );
        }
      },
    );
  }
}
