import 'package:flutter/material.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/blocs/tables_edit_bloc.dart';
import 'package:order_app/blocs/tables_edit_bloc_provider.dart';
import 'package:order_app/models/tables.dart';
import 'package:order_app/pages/edit_entry.dart';
import 'package:order_app/services/db_firestore.dart';



class QLBan extends StatefulWidget {
  @override
  _QLBanState createState() => _QLBanState();
}

class _QLBanState extends State<QLBan> {
  HomeBloc _homeBloc;
  String _uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _homeBloc.dispose();
    super.dispose();
  }


  void _addOrEditTaBles({bool add, TaBles taBles}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => TaBlesEditBlocProvider(
            taBlesEditBloc: TaBlesEditBloc(add, taBles, DbFirestoreService()),
            child: EditEntry(),
          ),
          fullscreenDialog: true
      ),
    );
  }

  // Confirm Deleting a Journal Entry
  Future<bool> _confirmDeleteJournal() async {
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
        title: Text('Quản Lý Bàn', style: TextStyle(color: Colors.lightGreen.shade800),),
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
        stream: _homeBloc.taBlesList,
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
                child: Text('Thêm Bàn.'),
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
        tooltip: 'Add TaBles Entry',
        backgroundColor: Colors.lightGreen.shade300,
        child: Icon(Icons.add),
        onPressed: () async {
          _addOrEditTaBles(add: true, taBles: TaBles(uid: _uid));
        },
      ),
    );
  }

  // Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _subtitle =  snapshot.data[index].note;
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
            title: Text(_subtitle),
            onTap: () {
              _addOrEditTaBles(
                add: false,
                taBles: TaBles(
                    documentID: snapshot.data[index].documentID,
                    note: snapshot.data[index].note,
                    uid: snapshot.data[index].uid
                ),
              );
            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteJournal();
            if (confirmDelete) {
              _homeBloc.xoaBan.add(snapshot.data[index]);
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