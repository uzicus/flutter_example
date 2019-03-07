
import 'package:flutter/material.dart';

class ContainerScrollView extends StatelessWidget {

  final Widget child;

  const ContainerScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, viewportConstraints) {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
          child: child,
        ),
      );
    });
  }

}