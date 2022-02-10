
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/category_edit_bloc_provider.dart';
import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/models/category.dart';
import 'package:order_app/models/food.dart';

class DropdownCategory extends StatefulWidget{
  DropdownCategoryState createState() => DropdownCategoryState();
}

class DropdownCategoryState extends State<DropdownCategory>{
  HomeBloc _categoryBloc;
  Category _category;

  FoodBloc _foodBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _categoryBloc = HomeBlocProvider.of(context).homeBloc;
    _foodBloc = FoodBlocProvider.of(context).foodBloc;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _categoryBloc.dispose();
    _foodBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Text(
          'Loại món:  ',
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500),
        ),
        StreamBuilder(
          stream: _categoryBloc.categoryList,
          builder: ((BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildCategory(snapshot.data);
            } else {
              return Center(
                child: Container(
                  child: Text('Add Food.'),
                ),
              );
            }
          }),
        )
      ],

    );
  }

  Widget _buildCategory( List<Category> categories) {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < categories.length; i++) {
      DropdownMenuItem item = DropdownMenuItem(
        value: categories[i],
        child: Text(
          categories[i].name,
          style: TextStyle(fontSize: 17.0),
        ),
      );
      items.add(item);
    }

   return DropdownButton(
        value: _category,
        items: items,
        onChanged: (values) {
          /*setState(() {
            _category = values;
            //
          });*/
          _foodBloc.idCategoryEditChanged.add(values.name);

        });
  }
}