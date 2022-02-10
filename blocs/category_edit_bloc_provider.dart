import 'package:flutter/material.dart';
import 'package:order_app/blocs/CategoryEditBloc.dart';



class CategoryEditBlocProvider extends InheritedWidget {
  final CategoryEditBloc categoryEditBloc;

  const CategoryEditBlocProvider(
      {Key key, Widget child, this.categoryEditBloc})
      : super(key: key, child: child);

  static CategoryEditBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CategoryEditBlocProvider>());
  }

  @override
  bool updateShouldNotify(CategoryEditBlocProvider old) => false;
}