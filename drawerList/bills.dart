import 'package:flutter/material.dart';
import 'package:order_app/blocs/authentication_bloc.dart';
import 'package:order_app/blocs/bill_bloc.dart';
import 'package:order_app/blocs/bill_bloc_provider.dart';
import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';

import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';

import 'package:order_app/constants/theme.dart' as theme;
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/pages/bill_detail.dart';
import 'package:order_app/pages/cart.dart';
import 'package:order_app/pages/edit_category.dart';
import 'package:order_app/services/authentication.dart';
import 'package:order_app/services/db_firestore.dart';

class BillScreen extends StatefulWidget {
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {

  HomeBloc _billBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _billBloc = HomeBlocProvider.of(context).homeBloc;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _billBloc.dispose();
    super.dispose();
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
        title: Text('Quản Lý Hóa Đơn', style: TextStyle(color: Colors.lightGreen.shade800),),
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
        stream: _billBloc.billList,
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
                child: Text('Add Bill.'),
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

    );
  }

  // Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = snapshot.data[index].dateCheckOut.toString();
        String _leading = snapshot.data[index].nameTable;
        String _trailing = snapshot.data[index].totalPrice.toString();
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
            leading: Text(_leading+'             ', style: TextStyle(fontSize: 18)),
            trailing: Text(_trailing.substring(0,2) + 'k'),
            onTap: () {
              _pushDetailsBillScreen(Bill(
                  documentID: snapshot.data[index].documentID,
                  nameTable: snapshot.data[index].nameTable,
                  uid: snapshot.data[index].uid,
                  discount: snapshot.data[index].discount,
                  dateCheckOut: snapshot.data[index].dateCheckOut,
                  totalPrice: snapshot.data[index].totalPrice
              ));

            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteItem();
            if (confirmDelete) {
              _billBloc.deleteBill.add(snapshot.data[index]);
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

  void _pushDetailsBillScreen(Bill bill) {
    final AuthenticationService _authenticationService = AuthenticationService();
    final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);
    Navigator.of(context).push(
      MaterialPageRoute(
          /*builder: (context) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Bill Detail',
                style: TextStyle(color: theme.accentColor),
              ),
              iconTheme: IconThemeData(color: theme.accentColor),
              centerTitle: true,
            ),
            body: BillDetailScreen(
              bill: bill,
            ));
      }*/
          builder: (BuildContext context) => HomeBlocProvider(
            homeBloc: HomeBloc(DbFirestoreService(), _authenticationService, bill.nameTable+bill.dateCheckOut,''),
            child: BillDetailScreen(bill: bill),
          ),
          fullscreenDialog: true
      ),
    );
  }
}