import 'package:flutter/cupertino.dart';

import 'food_bloc.dart';

class FoodBlocProvider extends InheritedWidget {
  final FoodBloc foodBloc;

  const FoodBlocProvider(
      {Key key, Widget child, this.foodBloc})
      : super(key: key, child: child);

  static FoodBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<FoodBlocProvider>());
  }

  @override
  bool updateShouldNotify(FoodBlocProvider old) => false;
}