import 'package:flutter/material.dart';

import 'package:stock_control_master/features/home/presentation/view/home_page.dart'
    show HomeScreen;

/// The pages displayed by [IndexedStack], in bottom-nav tab order.
List<Widget> buildIndexPages() {
  return <Widget>[HomeScreen(), Scaffold(), Scaffold(), Scaffold(), Scaffold()];
}
