import 'package:flutter/material.dart';

import '../../../home/presentation/home/view/home_page.dart' show HomeScreen;

/// The pages displayed by [IndexedStack], in bottom-nav tab order.
List<Widget> buildIndexPages() {
  return <Widget>[HomeScreen(), Scaffold(), Scaffold(), Scaffold(), Scaffold()];
}
