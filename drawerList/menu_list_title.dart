import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/authentication_bloc.dart';
import 'package:order_app/blocs/authentication_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/drawerList/bills.dart';
import 'package:order_app/drawerList/dash_board.dart';
import 'package:order_app/drawerList/qlban.dart';
import 'package:order_app/drawerList/qlfood.dart';
import 'package:order_app/drawerList/qlhoadon.dart';
import 'package:order_app/pages/home.dart';

import 'package:order_app/pages/login.dart';
import 'package:order_app/services/authentication.dart';
import 'package:order_app/services/db_firestore.dart';



class MenuListTitle extends StatelessWidget{

  
  
  @override
   Widget build(BuildContext context) {
    final AuthenticationService _authenticationService = AuthenticationService();
    final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);
    // TODO: implement build
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.table_chart),
          title: Text('Quản Lý Bàn'),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthenticationBlocProvider(
                  authenticationBloc: _authenticationBloc,
                  child: StreamBuilder(
                    initialData: null,
                    stream: _authenticationBloc.user,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.lightGreen,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return HomeBlocProvider(
                          homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',''), // Inject the DbFirestoreService() & AuthenticationService()
                          uid: snapshot.data,
                          child: QLBan(),
                        );
                      } else {
                        return _buildMaterialApp(Home());
                      }
                    },
                  ),
                  ),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('Quản Lý Danh Mục'),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthenticationBlocProvider(
                  authenticationBloc: _authenticationBloc,
                  child: StreamBuilder(
                    initialData: null,
                    stream: _authenticationBloc.user,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.lightGreen,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                          return HomeBlocProvider(
                            homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',''), // Inject the DbFirestoreService() & AuthenticationService()
                            uid: snapshot.data,
                            child: QLHoaDon(),
                          );
                      } else {
                        return _buildMaterialApp(Home());
                      }
                    },
                  ),
                ),
              ),

            );
          },
        ),
        ListTile(
          leading: Icon(Icons.free_breakfast),
          title: Text('Quản Lý Món Ăn'),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthenticationBlocProvider(
                  authenticationBloc: _authenticationBloc,
                  child: StreamBuilder(
                    initialData: null,
                    stream: _authenticationBloc.user,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.lightGreen,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return HomeBlocProvider(
                          homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',''), // Inject the DbFirestoreService() & AuthenticationService()
                          uid: snapshot.data,
                          child: QLFood(),
                        );
                      } else {
                        return _buildMaterialApp(Home());
                      }
                    },
                  ),
                ),
              ),

            );
          },
        ),
        ListTile(
          leading: Icon(Icons.assessment_outlined),
          title: Text('Quản Lý Hóa Đơn'),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthenticationBlocProvider(
                  authenticationBloc: _authenticationBloc,
                  child: StreamBuilder(
                    initialData: null,
                    stream: _authenticationBloc.user,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.lightGreen,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return HomeBlocProvider(
                          homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',''), // Inject the DbFirestoreService() & AuthenticationService()
                          uid: snapshot.data,
                          child: BillScreen(),
                        );
                      } else {
                        return _buildMaterialApp(Home());
                      }
                    },
                  ),
                ),
              ),

            );
          },
        ),
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text('Thống Kê'),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthenticationBlocProvider(
                  authenticationBloc: _authenticationBloc,
                  child: StreamBuilder(
                    initialData: null,
                    stream: _authenticationBloc.user,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.lightGreen,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return HomeBlocProvider(
                          homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',''), // Inject the DbFirestoreService() & AuthenticationService()
                          uid: snapshot.data,
                          child: DashBoardScreen(),
                        );
                      } else {
                        return _buildMaterialApp(Home());
                      }
                    },
                  ),
                ),
              ),

            );
          },
        ),
        Divider(color: Colors.grey,),
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.lightGreen.shade800,),
              onPressed: () {
                _authenticationBloc.logoutUser.add(true);
              },
         ),
          title: Text('Đăng Xuất'),
        ),
      ],
    );
  }
  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.lightGreen.shade50,
        bottomAppBarColor: Colors.lightGreen,
      ),
      home: homePage,
    );
  }
}