import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/authentication_bloc.dart';
import 'package:order_app/blocs/authentication_bloc_provider.dart';
import 'package:order_app/blocs/bill_bloc.dart';
import 'package:order_app/blocs/bill_bloc_provider.dart';
import 'package:order_app/blocs/bill_detail_bloc.dart';
import 'package:order_app/blocs/bill_detail_bloc_provider.dart';
import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/drawerList/drawer.dart';
import 'package:order_app/models/bill_detail.dart';
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/models/tables.dart';
import 'package:order_app/pages/cart.dart';
import 'package:order_app/services/authentication.dart';
import 'package:order_app/services/db_firestore.dart';
import 'package:order_app/constants/theme.dart' as theme;

import 'menu.dart';




class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;
  AuthenticationBloc _authenticationBloc;
  TaBles _taBles;
  Future<List<TaBles>> futureTables;
  TaBles _selectedTable;
  HomeBloc _homeBloc;
  String _uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_tabChanged);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;

    _authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _homeBloc.dispose();
    super.dispose();

  }

  void _tabChanged(){
    if(_tabController.indexIsChanging){
      print('tabChanged:${_tabController.index}');
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Food App'),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.green.shade800,),
            onPressed: (){
            _authenticationBloc.logoutUser.add(true);
          },
          ),*/
        ],
      ),
      drawer: DrawerWidget(),
      body:  Container(
        margin: EdgeInsets.all(5.0),
        child: StreamBuilder<List<TaBles>>(
          stream: _homeBloc.taBlesList,
          builder: ((BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasData) {
              return ListView.builder(
                  itemExtent: 100.0,
                  itemCount: (snapshot.data.length / 2).ceil(),
                  itemBuilder: (context, index) =>
                      _buildTableRow(context, index, snapshot.data));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        ),),
      ),


      /*bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.black54,
          unselectedLabelColor: Colors.black38,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: 'Trang Chủ',
            ),
            Tab(
              icon: Icon(Icons.free_breakfast),
              text: 'Gọi Món',
            ),
            Tab(
              icon: Icon(Icons.assessment_outlined),
              text: 'Thanh Toán',
            )
          ],
        ),
      ),*/
    );
  }
  Widget _buildTableRow(BuildContext context, int index, List<TaBles> tables) {
    List<TaBles> indexes = [];

    int end = (index + 1) * 3;
    if (end > tables.length - 1) end = tables.length;
    int begin = index * 3;

    for (int i = begin; i < end; i++) {
      indexes.add(tables[i]);
    }

    return Container(
      child: Row(children: _generateRow(context, indexes)),
    );
  }
  List<Widget> _generateRow(BuildContext context, List<TaBles> indexes) {
    List<Widget> items = [];

    for (int i = 0; i < indexes.length; i++) {
      Expanded expanded = Expanded(
        child: _buildTable(context, indexes[i]),
      );
      items.add(expanded);
    }

    for (int i = 0; i < 3 - indexes.length; i++) {
      Expanded expanded = Expanded(child: Container());
      items.add(expanded);
    }

    return items;
  }
  Widget _buildTable(BuildContext context, TaBles table) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTable = table;
        });
        _pushMenuScreen(table);
      },
      child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: Card(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    table.status == 1 ? Icons.people : Icons.people_outline,
                    size: 20.0,
                    color: table.status == 1 ? Colors.redAccent : Colors.redAccent,
                  ),
                ),
                //  Expanded(child:  Container()),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 30.0, right: 8.0),
                    child: Text(
                      table.note,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
  void _pushMenuScreen(TaBles table) {
    BillPlus bill;
    final AuthenticationService _authenticationService = AuthenticationService();
    final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return HomeBlocProvider(
          homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',''),

          /*child: BillPlusBlocProvider(
            billPlusBloc: BillPlusBloc(true, BillPlus(uid: _uid), DbFirestoreService()),
            child: MenuScreen(table: table),*/
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                  'Menu • ' + _selectedTable.note,
                  overflow: TextOverflow.ellipsis,
              ),
              //iconTheme: IconThemeData(color: Colors.lightGreen),
              centerTitle: true,
            ),
            body: //MenuScreen(),
            BillPlusBlocProvider(
              billPlusBloc: BillPlusBloc(false, BillPlus(uid: _uid), DbFirestoreService()),
              child: MenuScreen(table: table),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _pushCartScreen(table, context);
              },
              child: Icon(Icons.add_shopping_cart),
              tooltip: 'Add To Cart',
              backgroundColor: Colors.lightGreen,
            ),
          ),
        );
      }),
    );
  }
  void _pushCartScreen(TaBles table, BuildContext menuContext) {

    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return BillBlocProvider(
          billBloc: BillBloc(true, Bill(uid: _uid), DbFirestoreService()),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Giỏ hàng • ' + _selectedTable.note,
              ),
              //iconTheme: IconThemeData(color: Colors.lightGreen),
              centerTitle: true,
            ),
            body: //CartScreen(table: table, menuContext: context),
            BillPlusBlocProvider(
              billPlusBloc: BillPlusBloc(true, BillPlus(uid: _uid), DbFirestoreService()),
              child: CartScreen(table: table, menuContext: context),
            ),
          ),
        );/*
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Cart • ' + _selectedTable.note,
            ),
            iconTheme: IconThemeData(color: Colors.lightGreen),
            centerTitle: true,
          ),
          body: //CartScreen(table: table, menuContext: context),
          BillBlocProvider(
            billBloc: BillBloc(true, Bill(uid: _uid), DbFirestoreService()),
            child: CartScreen(table: table, menuContext: context),
          ),

        );
      }*/
      }),
    );
  }



}