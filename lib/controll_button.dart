import 'package:flutter/material.dart';

class ControllButton extends StatelessWidget {
  final Function? callback;
  final Color color;
  final String label;

  const ControllButton({
    Key? key,
    required this.callback,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15.0), primary: color),
          onPressed: callback == null ? null : () => callback!(),
          child: Text(label)),
    );
  }
}
