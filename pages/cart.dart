import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_app/blocs/bill_bloc.dart';
import 'package:order_app/blocs/bill_bloc_provider.dart';
import 'package:order_app/blocs/bill_detail_bloc.dart';
import 'package:order_app/blocs/bill_detail_bloc_provider.dart';
import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/constants/dialog.dart';
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/models/tables.dart';
import 'package:order_app/constants/theme.dart' as theme;
import 'package:order_app/constants/dialog.dart' as dialog;
import 'package:order_app/pages/menu.dart';
import 'package:order_app/services/db_firestore.dart';

class CartScreen extends StatefulWidget {
  CartScreen({key, this.table, this.menuContext})
      : super(key: key);

  final TaBles table;
  final BuildContext menuContext;

  @override
  _CartScreenState createState() => _CartScreenState();

}

class _CartScreenState extends State<CartScreen> {
  double _discount;
  BillBloc _billBloc;
  BillPlusBloc _billPlusBloc;
  HomeBloc _homeBloc;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _discount = 0.0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _billBloc = BillBlocProvider.of(context).billBloc;
    _billPlusBloc = BillPlusBlocProvider.of(context).billPlusBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
  }

  @override
  dispose() {
    _billBloc.dispose();
    _billPlusBloc.dispose();
    _homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildListFoods(context),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildListFoods(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5.0),
        child: ListView.builder(
            itemExtent: 130.0,
            itemCount: widget.table.fooda.length,
            itemBuilder: (BuildContext context, index) =>
                //_buildFood(context, widget.table.fooda[index])),
                  _buildFood(context, widget.table.fooda[index])),
      ),
    );
  }


  Widget _buildFood(BuildContext context, Food food) {
    return Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Card(
          color: theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Container()),
              Image.asset(
                'assets/images/food.png',
                width: 122.0,
                height: 122.0,
                fit: BoxFit.fill,
              ),
              Expanded(child: Container()),
              Column(
                children: <Widget>[
                  Expanded(child: Container()),
                  Text(
                    food.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: theme.fontColor,  fontSize: 20.0),
                  ),
                  Text(
                    food.price.toString().substring(0,2) + 'k',
                    style: const TextStyle(
                        color: theme.fontColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Container())
                ],
              ),
              Expanded(child: Container()),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 16.0,
                      color: theme.fontColorLight,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.table.subFood(food);
                      });
                    },
                  ),
                  Container(
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: theme.fontColor),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 4.0, right: 4.0),
                        child: Text(food.quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center),
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 16.0,
                      color: theme.fontColorLight,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.table.addFood(food);
                      });
                    },
                  ),
                ],
              ),
              Expanded(child: Container()),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 20.0,
                  color: theme.fontColorLight,
                ),
                onPressed: () {
                  setState(() {
                    widget.table.deleteFood(food);
                  });
                },
              ),
              Expanded(child: Container()),
            ],
          ),
        ));
  }

  Widget _buildControls(BuildContext context) {
    TextStyle _itemStyle =
    TextStyle(color: theme.fontColor,  fontSize: 16.0, fontWeight: FontWeight.w500);

    TextStyle _itemStyle2 =
    TextStyle(color: Colors.redAccent,  fontSize: 16.0, fontWeight: FontWeight.w500);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: theme.fontColorLight.withOpacity(0.2)),
          color: theme.primaryColor),
      margin: EdgeInsets.only(top: 2.0, bottom: 7.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Tổng: ',
                style: _itemStyle,
              ),
              Expanded(child: Container()),
              Text(
                widget.table.getTotalPrice().toStringAsFixed(2).substring(0,2) + 'k',
                style: _itemStyle,
              )
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Giảm giá: ',
                style: _itemStyle,
              ),
              Expanded(child: Container()),
              Container(
                width: 21.0,
                alignment: Alignment(1.0, 0.0),
                child: TextField(
                    controller: _textController,
                    style: _itemStyle,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (double.parse(value) > 100 || double.parse(value) < 0) {
                        _textController.clear();
                        value = '0.0';
                      }
                      setState(() {
                        _discount = double.parse(value);
                      });
                    },
                    onSubmitted: null,
                    decoration: InputDecoration.collapsed(hintText: '0%', hintStyle: _itemStyle)),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Thành tiền: ',
                style: _itemStyle,
              ),
              Expanded(child: Container()),
              Text(
                 (widget.table.getTotalPrice() * (100 - _discount) / 100).toStringAsFixed(2).substring(0,2) + 'k',
                style: _itemStyle2,
              )
            ],
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.redAccent,
                child: Text(
                  'Thanh Toán',
                  style: _itemStyle,
                ),
                onPressed: () {
                  if (widget.table.fooda.isNotEmpty)
                    _checkOut(context);
                  else
                    _error(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _error(BuildContext cartContext) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error', style: theme.errorTitleStyle),
            content: Text('Không thể thanh toán ' + widget.table.note + '!' + '\nVui lòng chọn món!',
                style: theme.contentStyle),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: theme.okButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(cartContext).pop();
                },
              )
            ],
          );
        });
  }

  void _checkOut(BuildContext cartContext) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm', style: theme.titleStyle),
            content:
            Text('Bạn có chắc chắn muốn thanh toán ' + widget.table.note + '?', style: theme.contentStyle),
            actions: <Widget>[
              FlatButton(
                child: Text('Đồng Ý', style: theme.okButtonStyle),
                onPressed: () async {

                  Navigator.of(context).pop();
                  bool isSend = true;
                  String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString();
                  if (isSend) {
                    // exists bill
                    Navigator.of(cartContext).pop();

                    if (true) {
                      _billBloc.tableEditChanged.add(widget.table.note);
                      _billBloc.checkOutEditChanged.add(date);
                      _billBloc.discountEditChanged.add(_discount);
                      _billBloc.totalPriceEditChanged.add(widget.table.getTotalPrice() * (100 - _discount) / 100);
                      _billBloc.saveChanged.add('Save');


                      for(int k=0; k < widget.table.fooda.length; k++){
                        _billPlusBloc.foodNameEditChanged.add(widget.table.fooda[k].name);
                        _billPlusBloc.numFoodEditChanged.add(widget.table.fooda[k].quantity);
                        _billPlusBloc.priceEditChanged.add(widget.table.fooda[k].price);
                        _billPlusBloc.idBillEditChanged.add(widget.table.note+date.toString());
                        _billPlusBloc.saveChanged.add('Save');
                      }
                      widget.table.status = -1;
                      widget.table.foods.clear();

                      Navigator.of(widget.menuContext).pop();
                    }
                  }
                },
              ),
              FlatButton(
                child: Text('Đóng', style: theme.cancelButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}