import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/CategoryEditBloc.dart';
import 'package:order_app/blocs/category_edit_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/models/category.dart';
import 'package:order_app/pages/edit_category.dart';
import 'package:order_app/services/db_firestore.dart';

class QLHoaDon extends StatefulWidget{
  QLHoaDonState createState() => QLHoaDonState();
}

class QLHoaDonState extends State<QLHoaDon>{
  HomeBloc _categoryBloc;
  String _uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoryBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _categoryBloc.dispose();
    super.dispose();
  }


  void _addOrEditItem({bool add, Category category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => CategoryEditBlocProvider(
            categoryEditBloc: CategoryEditBloc(add, category, DbFirestoreService()),
            child: EditCategory(),
          ),
          fullscreenDialog: true
      ),
    );
  }

  // Confirm Deleting a Journal Entry
  Future<bool> _confirmDeleteItem() async {
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
        title: Text('Quản Lý Danh Mục Món', style: TextStyle(color: Colors.lightGreen.shade800),),
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
        stream: _categoryBloc.categoryList,
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
                child: Text('Add Category.'),
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
        tooltip: 'Add Category Entry',
        backgroundColor: Colors.lightGreen.shade300,
        child: Icon(Icons.add),
        onPressed: () async {
          _addOrEditItem(add: true, category: Category(uid: _uid));
        },
      ),
    );
  }

  // Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _title =  snapshot.data[index].name;
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
          child: ListTile(
            title: Text(_title),
            onTap: () {
              _addOrEditItem(
                add: false,
                category: Category(
                    documentID: snapshot.data[index].documentID,
                    name: snapshot.data[index].name,
                    uid: snapshot.data[index].uid
                ),
              );
            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteItem();
            if (confirmDelete) {
              _categoryBloc.deleteCategory.add(snapshot.data[index]);
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