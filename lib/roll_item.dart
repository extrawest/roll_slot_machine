import 'package:flutter/material.dart';

class RollItem extends StatelessWidget {
  final int index;
  final Widget child;

  const RollItem({required this.index, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
