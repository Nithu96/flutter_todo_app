import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/services/crud_config.dart';

class TodoList extends StatefulWidget {
   const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late String cartModel;
  late String cartDescription;

  //QuerySnapshot cars;
  late Stream<QuerySnapshot> cars;

  crudMethods crudObj = crudMethods();

  void addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Add TODO Item',
              style: TextStyle(fontSize: 18, color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(hintText: 'Title'),
                    onChanged: (value) {
                      cartModel = value;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Description'),
                    onChanged: (value) {
                      cartDescription = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Map<String, dynamic> cartData = {
                    'title': cartModel,
                    'disc': cartDescription
                  };
                  crudObj.addData(cartData).then((result) {
                    dialogTrigger(context);
                    initState();
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  void updateDialog(BuildContext context, selectedDoc, data) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Update Data',
              style: TextStyle(fontSize: 15, color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
             child: ListBody(
               children: <Widget>[
                 TextFormField(
                   decoration: const InputDecoration(hintText: 'Title'),
                   initialValue: data['title'],
                   onChanged: (value) {
                     cartModel = value;
                   },
                 ),
                 const SizedBox(
                   height: 5,
                 ),
                 TextFormField(
                   decoration: const InputDecoration(hintText: 'Description'),
                   initialValue: data['disc'],
                   onChanged: (value) {
                     cartDescription = value;
                   },
                 )
               ],
             ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Map<String, dynamic> cartData = {
                    'title': cartModel,
                    'disc': cartDescription
                  };
                  crudObj.updateData(selectedDoc, cartData).then((result) {
                    dialogTrigger(context);
                    initState();
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  void dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Cart Adding Note',
              style: TextStyle(fontSize: 15,color: Colors.blue ),
            ),
            content: const Text('Successful..!',
              style: TextStyle(fontSize: 15,color: Colors.blue ),
            ),

            actions: <Widget>[
              TextButton(
                child: const Text('Alright'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  bool isLoading = true;

  @override
  // ignore: must_call_super
  void initState() {
    crudObj.getData().then((result) {
      setState(() {
        cars = result;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
        centerTitle: true,
        // leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => const HomeScreen()),
        //       );
        //     }),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addDialog(context);
            },
          )
        ],
      ),
      body: _carList(),
    );
  }

  Widget _carList() {
    return isLoading
        ? const Text('Loading, Please wait..')
        : StreamBuilder<QuerySnapshot>(
            stream: cars,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? const Text('Loading, Please wait..')
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.all(5.0),
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(snapshot.data!.docs[i]['title']),
                          subtitle: Text(snapshot.data!.docs[i]['disc']),
                          onTap: () {
                            updateDialog(context, snapshot.data!.docs[i].id,
                                snapshot.data!.docs[i]);
                          },
                          onLongPress: () {
                            crudObj.deleteData(snapshot.data!.docs[i].id);
                          },
                        );
                      });
            });
  }
}
