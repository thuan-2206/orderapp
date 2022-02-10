import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/pages/addFood.view.dart';


import 'package:order_app/services/db_firestore.dart';

class QLFood extends StatefulWidget {
  @override
  _QLFoodState createState() => _QLFoodState();
}

class _QLFoodState extends State<QLFood> {
  HomeBloc _foodBloc;
  String _uid;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _foodBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _foodBloc.dispose();
    super.dispose();
  }


  void _addOrEditFood({bool add, Food food}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => FoodBlocProvider(
            foodBloc: FoodBloc(add, food, DbFirestoreService()),
            child: AddFoodScreen(),
          ),
          fullscreenDialog: true
      ),
    );
  }


  // Confirm Deleting a Journal Entry
  Future<bool> _confirmDeleteFood() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xóa"),
          content: Text("Bạn có chắc chắn xóa?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text('Xóa', style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Món', style: TextStyle(color: Colors.lightGreen.shade800),),
        elevation: 0.0,
        bottom: PreferredSize(child: Container(), preferredSize: Size.fromHeight(32.0)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _foodBloc.foodList,
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _buildListViewSeparated(snapshot);
          } else {
            return Center(
              child: Container(
                child: Text('Add Food.'),
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          height: 44.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen.shade50, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Food Entry',
        backgroundColor: Colors.lightGreen.shade300,
        child: Icon(Icons.add),
        onPressed: () async {
          _addOrEditFood(add: true, food: Food(uid: _uid));
        },
      ),
    );
  }

  // Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {

    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _title =  snapshot.data[index].idFoodCategory;
        String _leading = snapshot.data[index].name;
        String _trailing = snapshot.data[index].price.toString();
        return Dismissible(
          key: Key(snapshot.data[index].documentID),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Column(
            children: <Widget>[
              /*Table(
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Food Name'),
                          ],
                        ),
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Category'),
                          ],
                        ),
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Price'),
                          ],
                        ),
                      ),
                    ]
                  ),
                ]
              ),*/
              ListTile(
                title: Text(_title),
                leading: Text(_leading, style: TextStyle(fontSize: 18)),
                trailing: Text(_trailing.substring(0,2) + 'k'),

                //subtitle: Text(_subtitle+'đ'),
                onTap: () {
                  _addOrEditFood(
                    add: false,
                    food: Food(
                        documentID: snapshot.data[index].documentID,
                        name: snapshot.data[index].name,
                        idFoodCategory: snapshot.data[index].idFoodCategory,
                        price: snapshot.data[index].price,
                        uid: snapshot.data[index].uid
                    ),

                  );
                },
              ),
            ],
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteFood();
            if (confirmDelete) {
              _foodBloc.deleteFood.add(snapshot.data[index]);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
    );
  }
}