import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  bool isComplet = false;
  TextEditingController todoTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // back button in navigator
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("TODO List"),
        centerTitle: true,
        leading: IconButton(
          icon:Icon(Icons.arrow_back,color:Colors.white),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
              SizedBox(height: 20),
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.redAccent,
                  ),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Dismissible(
                    key: Key(index.toString()),
                    background: Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete),
                    color: Colors.red,
                    ),
                    onDismissed: (direction){
                      print("removed");
                    },
                    child: ListTile(
                        onTap: () {
                          setState(() {
                            isComplet = !isComplet;
                          });
                        },
                        leading: Container(
                          padding: EdgeInsets.all(2),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: isComplet
                              ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                              : Container(),
                        ),
                        title: Text(
                          "todo title",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    "Add Todo",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              children: [
                Divider(),
                TextFormField(
                  controller: todoTitleController,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "eg. exercise",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Add"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: ()  {

                    },
                  ),
                )
              ],
            ), context: context,
          );
        },
      ),
    );
  }
}
