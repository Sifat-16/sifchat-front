import 'package:flutter/widgets.dart';

class Size{
  BuildContext context;
  Size({required this.context});

  double get height => MediaQuery.of(this.context).size.height;
  double get width => MediaQuery.of(this.context).size.width;

}