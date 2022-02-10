import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'menu_list_title.dart';

class DrawerWidget extends StatelessWidget{
  const DrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              currentAccountPicture: Icon(
                Icons.face,
                size: 48.0,
                color: Colors.white,
              ),
              otherAccountsPictures: <Widget>[
                Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                ),
              ],
          ),

          MenuListTitle(),
        ],
      )
    );
  }
}