import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_app/blocs/authentication_bloc.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/drawerList/bills.dart';
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/constants/theme.dart' as theme;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:order_app/services/authentication.dart';
import 'package:order_app/services/db_firestore.dart';

class DashBoardScreen extends StatefulWidget {
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }*/


  HomeBloc _homeBloc;
  String _uid;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _homeBloc.dispose();
    super.dispose();
  }



  int currentI = 0;
  TextStyle _itemStyle =
  TextStyle(color: theme.fontColor, fontSize: 16.0);

  TextStyle _itemStyle2 = TextStyle(
      color: theme.accentColor,
      fontSize: 34.0,
      fontWeight: FontWeight.w600);

  TextStyle _itemStytle3 = TextStyle(
      color: theme.accentColor,
      fontWeight: FontWeight.w400,
      fontSize: 14.0);

  static final List<String> chartDropdownItems = [
    'Tuần này',
    'Tháng này',
    'Năm này'
  ];
  String totalMoneyToday = '';
  String totalMoney = '';
  String currentItem = chartDropdownItems[0];
  DateFormat format = DateFormat.Md();

  @override
  Widget build(BuildContext context) {

    Widget boxToday = _buildTile(
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hôm nay', style: _itemStyle),
                  StreamBuilder(
                    stream: _homeBloc.billList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Bill> rp = snapshot.data;
                          double sum = 0.00;
                          for (var i = 0; i < rp.length; ++i) {
                            if(rp[i].dateCheckOut.substring(0,10) == DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()){
                              sum += (rp[i].totalPrice);
                            }
                          }

                          totalMoneyToday = _roundMoney(sum) + 'k';

                          //totalMoneyToday = '\$' + _roundMoney(rp[0].totalPrice);
                        }
                      return Text('$totalMoneyToday', style: _itemStyle2);
                    },
                  )
                ],
              ),
              Material(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(24.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.timeline,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ), func: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          /*return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Bill',
                  style: TextStyle(color: theme.accentColor),
                ),
                iconTheme: IconThemeData(color: theme.accentColor),
                centerTitle: true,
              ),
              body: BillScreen());*/
          final AuthenticationService _authenticationService = AuthenticationService();
          final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);
          return HomeBlocProvider(
            homeBloc: HomeBloc(DbFirestoreService(), _authenticationService,'',DateFormat('yyyy-MM-dd').format(DateTime.now())), // Inject the DbFirestoreService() & AuthenticationService()
            uid: _uid,
            child: BillScreen(),
          );
        }),
      ).then((value) {
        setState(() {
          _reloadData(currentI);
        });
      });
    });

    Widget boxChart = _buildTile(Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Tổng', style: _itemStyle),
                      StreamBuilder(
                        stream: _homeBloc.billList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) _buildTotalMoney(snapshot.data);
                          return Text('$totalMoney', style: _itemStyle2);
                        },
                      )
                    ]),
                DropdownButton(
                    isDense: true,
                    value: currentItem,
                    onChanged: (String value) =>
                        setState(() {
                          currentItem = value;
                          for (var i = 0; i < chartDropdownItems.length; ++i) {
                            if (value == chartDropdownItems[i]) {
                              _reloadData(i);
                              currentI = i;
                            }
                          }
                        }),
                    items: chartDropdownItems.map((String title) {
                      return DropdownMenuItem(
                        value: title,
                        child: Text(title, style: _itemStytle3),
                      );
                    }).toList()),
              ]),
          Padding(padding: EdgeInsets.only(bottom: 2.0)),
          SizedBox(
            child: StreamBuilder(
              stream: _homeBloc.billList,
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  List<Bill> rps = snapShot.data;
                  double sumTotal = 0;
                  for (var i = 0; i < rps.length; ++i) {
                    for (var j = 1; j < rps.length; ++j){
                      if(format.format(DateTime.parse(rps[i].dateCheckOut)) == format.format(DateTime.parse(rps[j].dateCheckOut))){
                        sumTotal += rps[j].totalPrice;
                        //rps[j].totalPrice = sumTotal;
                        //rps.add(Bill(dateCheckOut: rps[i].dateCheckOut.toString(), totalPrice: sumTotal, uid: _uid, discount: 0, nameTable: ''));
                      }
                    }
                  }

                  return _buildChart(snapShot.data);
                }else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
            height: 250,
          )
        ],
      ),
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống Kê', style: TextStyle(color: Colors.lightGreen.shade800),),
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
      body: Container(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: ListView(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 12.0),
                  boxToday,
                  SizedBox(height: 12.0),
                  boxChart, // charts.LineChart(seriesList, animate: false,)
                ],
              ),
            ],
          )
      ),
    );
    /*return Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: ListView(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 12.0),
                boxToday,
                SizedBox(height: 12.0),
                boxChart, // charts.LineChart(seriesList, animate: false,)
              ],
            ),
          ],
        ));*/
  }

  Widget _buildTile(Widget child, {Function() func}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
        child: child,
        onTap: func,
      ),
    );
  }

  Widget _buildChart(List<Bill> rp) {
    return charts.BarChart(
      _parseSeries(rp),
      animate: true,
      //dateTimeFactory: const charts.LocalDateTimeFactory(),
      //defaultRenderer:  charts.LineRendererConfig(includePoints: true, includeArea: true),
    );
  }

  void _buildTotalMoney(List<Bill> rp) {
    double sum = 0.0;
    for (var i = 0; i < rp.length; ++i) {
      sum += rp[i].totalPrice;
    }

    totalMoney = _roundMoney(sum) + 'k';

    /*for (var i = 0; i < rp.length; ++i) {
      for (var j = 1; j < rp.length; ++j){
        if(format.format(DateTime.parse(rp[i].dateCheckOut)) == format.format(DateTime.parse(rp[j].dateCheckOut))){
          sum += rp[j].totalPrice;
        }
      }
    }*/
  }

  void _reloadData(int id) {

    switch (id) {
      case 0:
        _homeBloc.billList;
        //reports = _homeBloc.billList;
        format = DateFormat('MM-dd');
        break;
      case 1:
        _homeBloc.billList;
        //reports = _homeBloc.billList;
        format = DateFormat('yyyy-MM');
        break;
      default:
        _homeBloc.billList;
        //reports = _homeBloc.billList;
        format = DateFormat('yyyy');
        break;
    }
  }

  List<charts.Series<Bill, String>> _parseSeries(List<Bill> reports) {
    return [
      charts.Series<Bill, String>(
          id: 'totalPrice',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Bill rp, index) {
            return format.format(DateTime.parse(rp.dateCheckOut));
          },
          measureFn: (Bill rp, index) {
            return rp.totalPrice;
          },
          data: reports),
    ];
  }

  double _totalPrice(Bill rp, double price, DateFormat format){
    double sum = 0;
    if(format.format(DateTime.parse(rp.dateCheckOut)) == format.format(DateTime.parse(rp.dateCheckOut))){
          sum += price;
    }
    return sum;
  }

  String _roundMoney(double money) {
    int round = money.toInt();
    if (round < 1000) return round.toString();
    if (round < 1000000) return (money / 1000).round().toString() + 'M';
    if (round < 1000000000)
      return (money / 1000000).round().toString() + 'B';
    else
      return (money / 1000000000).round().toString() + 'KB';
  }
}