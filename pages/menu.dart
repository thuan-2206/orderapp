
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/authentication_bloc.dart';
import 'package:order_app/blocs/bill_bloc_provider.dart';
import 'package:order_app/blocs/bill_detail_bloc.dart';
import 'package:order_app/blocs/bill_detail_bloc_provider.dart';
import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/constants/theme.dart';
import 'package:order_app/models/bill_detail.dart';
import 'package:order_app/models/category.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/models/tables.dart';
import 'package:order_app/models/food_item.dart' as menu;
import 'package:order_app/pages/cart.dart';
import 'package:order_app/services/authentication.dart';
import 'package:order_app/services/db_firestore.dart';

class MenuScreen extends StatefulWidget{
  MenuScreen({key, this.table}) : super(key: key);

  final TaBles table;

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  HomeBloc _homeBloc;
  BillPlusBloc _billPlusBloc;
  BillPlus _billPlus;
  String _currentCategory;
  String _selectedCategory;
  String _uid;

  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _currentCategory = 'All';
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _billPlusBloc = BillPlusBlocProvider.of(context).billPlusBloc;
  }

  @override
  dispose() {
    _homeBloc.dispose();
    _billPlusBloc.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildFilterFood(context),
          StreamBuilder<List<Food>>(
            stream: _homeBloc.foodList,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? _buildListFoods(context, snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }


  Widget _buildTile(BuildContext context, List<Food> _foods, {Function() func}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: func,
      ),
    );
  }

  Widget _buildListFoods(BuildContext context, List<Food> _foods){
    List<Food> foods = widget.table.combineFoods(_foods);

    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5.0),
        child: ListView.builder(
            itemExtent: 175.0,
            itemCount: (foods.length / 2).ceil(),
            itemBuilder: (_, index) => _buildFoodRow(context, index, foods)),
      ),
    );
  }

  Widget _buildFoodRow(BuildContext context, int index, List<Food> foods) {
    List<Food> indexes = [];

    int end = (index + 1) * 2;
    if (end > foods.length - 1) end = foods.length;
    int begin = index * 2;

    for (int i = begin; i < end; i++) {
      indexes.add(foods[i]);
    }

    return Container(
      child: Row(children: _generateRow(context, indexes)),
    );
  }

  List<Widget> _generateRow(BuildContext context, List<Food> indexes) {
    List<Widget> items = [];

    for (int i = 0; i < indexes.length; i++) {
      Expanded expanded = Expanded(child: _buildFood(context, indexes[i]));

      items.add(expanded);
    }

    for (int i = 0; i < 2 - indexes.length; i++) {
      Expanded expanded = Expanded(child: Container());
      items.add(expanded);
    }

    return items;
  }

  Widget _buildFood(BuildContext context, Food food) {
    return Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Card(
          color: primaryColor,
          child: Column(
            children: <Widget>[
              Text(
                food.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: fontColor, fontSize: 20.0),
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Container()),
                  Image.asset(
                    'assets/images/food.png',
                    width: 122.0,
                    height: 122.0,
                    fit: BoxFit.fill,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          size: 16.0,
                          color: fontColorLight,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.table.subFood(food);
                          });
                        },
                      ),
                      Container(
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: fontColor),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 4.0, right: 4.0),
                            child: Text(
                              food.quantity.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 16.0,
                          color: fontColorLight,
                        ),

                        onPressed: () {
                          setState(() {
                            widget.table.addFood(food);
                          });


                        },
                      ),
                    ],
                  ),
                  Expanded(child: Container())
                ],
              ),
              Text(
                food.price.toString().substring(0,2) + 'k',
                style: const TextStyle(
                    color: fontColor,  fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }


  Widget _buildFilterFood(BuildContext context) {
    const TextStyle _itemStyle = TextStyle(color: fontColor,  fontSize: 16.0);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: fontColorLight.withOpacity(0.2))),
      margin: EdgeInsets.only(top: 10.0, bottom: 2.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                        controller: _textController,
                        onChanged: (keyword) {
                          setState(() {
                            ///Search();
                          });
                        },
                        onSubmitted: null,
                        style: _itemStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Nhập tên món ăn...',
                          hintStyle: _itemStyle,
                        ))),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: StreamBuilder<List<Category>>(
              stream: _homeBloc.categoryList,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? _buildFoodCategories(snapshot.data, _itemStyle)
                    : Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFoodCategories(List<Category> foodCategories, TextStyle _itemStyle) {
    List<DropdownMenuItem> items = [
      DropdownMenuItem(
        value: 'All',
        child: Text(
          'Tất cả',
          style: _itemStyle,
        ),
      )
    ];

    for (int i = 0; i < foodCategories.length; i++) {
      DropdownMenuItem item = DropdownMenuItem(
        value: foodCategories[i].name,
        child: Text(
          foodCategories[i].name,
          style: _itemStyle,
        ),
      );

      items.add(item);
    }

    return DropdownButton(
        value: _currentCategory,
        items: items,
        onChanged: (selectedCategory) {
          _selectedCategory = selectedCategory;
          setState(() {
            _currentCategory = selectedCategory;
            ///futureFoods = Controller.instance.filterFoods(selectedCategory);

            // clear keyword
            _textController.text = '';
          });
        });
  }

}