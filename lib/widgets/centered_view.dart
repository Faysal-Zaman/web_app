import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  Widget? child;
  CenteredView({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 60),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: child,
        ),
      ),
    );
  }
}
