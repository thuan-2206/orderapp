
import 'package:intl/intl.dart';
import 'package:order_app/blocs/bill_bloc.dart';
import 'package:order_app/blocs/bill_bloc_provider.dart';
import 'package:order_app/blocs/food_bloc.dart';
import 'package:order_app/blocs/food_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/constants/theme.dart' as theme;
import 'package:flutter/material.dart';
import 'package:order_app/models/bill_detail.dart';
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/models/tables.dart';

class BillDetailScreen extends StatefulWidget {
  BillDetailScreen({key, this.bill}) : super(key: key);

  final Bill bill;

  _BillDetailScreenState createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {

  HomeBloc _homeBloc;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi Tiết Hóa Đơn',
          style: TextStyle(color: theme.accentColor),
        ),
        iconTheme: IconThemeData(color: theme.accentColor),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildHeader(), _buildBody(context), _buildFooter()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Card(
              color: Colors.lightBlueAccent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.bill.nameTable,
                  style: TextStyle(
                    color: theme.fontColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
          Expanded(
            child: Container(),
          ),
          Column(
            children: <Widget>[
              Text(
                widget.bill.dateCheckOut.toString(),
                style: TextStyle(
                    color: theme.fontColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Expanded(
      child: Container(
          margin: EdgeInsets.all(5.0),
          child: StreamBuilder(
            stream: _homeBloc.billPlusList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemExtent: 60.0,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) => _buildFood(snapshot.data[index]));
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        /*child: Container(
          margin: EdgeInsets.all(5.0),
          child: ListView.builder(
              itemExtent: 60.0,
              itemCount: widget.bill.table.fooda.length,
              itemBuilder: (_, index) => _buildFood(widget.bill.table.fooda[index])),
        ),*/
      ),
    );
    /*return Expanded(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ListView.builder(
            itemExtent: 60.0,
            itemCount: widget.bill.table.fooda.length,
            itemBuilder: (_, index) => _buildFood(widget.bill.table.fooda[index])),
      ),
    );*/
  }

  Widget _buildFood( BillPlus food) {
    return Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Card(
          color: theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Expanded(child: Container()),
              Text(
                food.foodName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: theme.accentColor,  fontSize: 18.0),
              ),
              Expanded(child: Container()),
              Text(
                food.price.toString().substring(0,2) + 'k',
                style: const TextStyle(
                    color: theme.fontColorLight,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(child: Container()),
              Text(
                food.numFood.toString(),
                style: const TextStyle(
                    color: theme.fontColorLight,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(child: Container()),
              Text(
                (food.numFood * food.price).toString().substring(0,2) + 'k',
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
              ),
              //Expanded(child: Container()),
            ],
          ),
        ));
  }

  Widget _buildFooter() {
    TextStyle _itemStyle = TextStyle(
        color: theme.fontColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    TextStyle _itemStyle2 = TextStyle(
        color: Colors.redAccent,
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

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
                (widget.bill.totalPrice*100/(100-widget.bill.discount)).toStringAsFixed(2).substring(0,2) + 'k',
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
              Text(
                widget.bill.discount.toString() + '%',
                style: _itemStyle,
              )
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
                widget.bill.totalPrice.toStringAsFixed(2).substring(0,2) + 'k',
                style: _itemStyle2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
