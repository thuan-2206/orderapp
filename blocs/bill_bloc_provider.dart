import 'package:flutter/material.dart';
import 'package:order_app/blocs/bill_bloc.dart';

class BillBlocProvider extends InheritedWidget {
  final BillBloc billBloc;

  const BillBlocProvider(
      {Key key, Widget child, this.billBloc})
      : super(key: key, child: child);

  static BillBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<BillBlocProvider>());
  }

  @override
  bool updateShouldNotify(BillBlocProvider old) => false;
}