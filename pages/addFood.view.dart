
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/authentication_bloc.dart';

import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/blocs/image_bloc.dart';
import 'package:order_app/constants/theme.dart' as theme;
import 'package:order_app/models/category.dart';
import 'package:order_app/pages/DropdownCategory.dart';
import 'package:order_app/services/authentication.dart';
import 'package:order_app/services/db_firestore.dart';





class AddFoodScreen extends StatefulWidget {
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  FoodBloc _foodBloc;
  HomeBloc _categoryBloc;

  TextEditingController _nameController ;
  TextEditingController _idCategoryController;
  TextEditingController _priceController ;

  Category _category;



  File _image;

  @override
  void initState() {
    _nameController = TextEditingController();
    _nameController.text = '';
    _idCategoryController = TextEditingController();
    _idCategoryController.text = '';
    _priceController = TextEditingController();
    _priceController.text = '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _foodBloc = FoodBlocProvider.of(context).foodBloc;
    _categoryBloc = HomeBlocProvider.of(context).homeBloc;
  }

  @override
  dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _idCategoryController.dispose();
    _categoryBloc.dispose();
    _foodBloc.dispose();
    super.dispose();
  }

  void _addOrUpdateFood() {
   _foodBloc.saveChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final AuthenticationService _authenticationService = AuthenticationService();
    final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);

    TextStyle _itemStyle = TextStyle(
        color: theme.fontColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    TextStyle _itemStyle2 = TextStyle(
        color: theme.accentColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Món Ăn', style: TextStyle(color: Colors.lightGreen.shade800),),
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
              children: <Widget>[
                _image == null
                    ? Image.asset(
                  'assets/images/food.png',
                  width: 122.0,
                  height: 122.0,
                  fit: BoxFit.fill,
                )
                    : Image.file(
                  _image,
                  width: 122.0,
                  height: 122.0,
                  fit: BoxFit.fill,
                ),
                Container(
                  height: 15.0,
                ),
                RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'Chọn hình ảnh',
                    style: _itemStyle,
                  ),
                  onPressed: () async {
                    var image = await ImageBloc.getImageFromGallery();
                    setState(() {
                      _image = image;
                    });
                  },
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                        stream: _foodBloc.nameEdit,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          // Use the copyWith to make sure when you edit TextField the cursor does not bounce to the first character
                          _nameController.value = _nameController.value.copyWith(text: snapshot.data);
                          return TextField(
                            controller: _nameController,
                            textInputAction: TextInputAction.newline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Tên món',
                              icon: Icon(Icons.subject),
                            ),
                            maxLines: null,
                            onChanged: (name) => _foodBloc.nameEditChanged.add(name),
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: _foodBloc.idCategoryEdit,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          //_idCategoryController.value = _idCategoryController.value.copyWith(text: snapshot.data);
                          return HomeBlocProvider(
                            homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',''), // Inject the DbFirestoreService() & AuthenticationService()
                            uid: snapshot.data,
                            child: DropdownCategory(),
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: _foodBloc.priceEdit,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.newline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Giá tiền',
                              icon: Icon(Icons.subject),
                            ),
                            maxLines: null,
                            onChanged: (price) => _foodBloc.priceEditChanged.add(double.parse(price)),
                          );
                        }
                      ),
                    ],
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('Đóng'),
                  color: Colors.grey.shade100,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8.0),
                FlatButton(
                  child: Text('Lưu'),
                  color: Colors.lightGreen.shade100,
                  onPressed: () {
                    _addOrUpdateFood();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
