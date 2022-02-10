import 'package:flutter/material.dart';
import 'package:order_app/blocs/tables_edit_bloc.dart';



class TaBlesEditBlocProvider extends InheritedWidget {
  final TaBlesEditBloc taBlesEditBloc;

  const TaBlesEditBlocProvider(
      {Key key, Widget child, this.taBlesEditBloc})
      : super(key: key, child: child);

  static TaBlesEditBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<TaBlesEditBlocProvider>());
  }

  @override
  bool updateShouldNotify(TaBlesEditBlocProvider old) => false;
}