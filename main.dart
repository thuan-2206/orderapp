import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';
import 'package:order_app/drawerList/qlfood.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/pages/addFood.view.dart';
import 'package:order_app/pages/home.dart';
import 'package:order_app/pages/login.dart';
import 'package:order_app/services/authentication.dart';
import 'package:order_app/services/db_firestore.dart';


import 'blocs/authentication_bloc.dart';
import 'blocs/authentication_bloc_provider.dart';
import 'blocs/home_bloc.dart';
import 'blocs/home_bloc_provider.dart';

void main() => {
  WidgetsFlutterBinding.ensureInitialized(),
  runApp(MyApp()),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService = AuthenticationService();
    final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);

    return AuthenticationBlocProvider(
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
              child: _buildMaterialApp(Home()),
            );
          } else {
            return _buildMaterialApp(Login());
          }
        },
      ),
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
