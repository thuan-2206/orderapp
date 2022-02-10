import 'package:flutter/material.dart';
import 'package:order_app/blocs/bill_detail_bloc.dart';

class BillPlusBlocProvider extends InheritedWidget {
  final BillPlusBloc billPlusBloc;

  const BillPlusBlocProvider(
      {Key key, Widget child, this.billPlusBloc})
      : super(key: key, child: child);

  static BillPlusBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<BillPlusBlocProvider>());
  }

  @override
  bool updateShouldNotify(BillPlusBlocProvider old) => false;
}