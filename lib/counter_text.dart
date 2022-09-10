import 'package:flutter/material.dart';

class CounterText extends StatelessWidget {
  const CounterText(this.count, {Key? key}) : super(key: key);

  final int count;
  @override
  Widget build(BuildContext context) {
    return Text('$count');
  }
}
