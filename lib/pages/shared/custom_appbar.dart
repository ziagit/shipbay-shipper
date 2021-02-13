import 'package:flutter/material.dart';
import 'package:shipbay/services/settings.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      iconTheme: IconThemeData(color: primary),
      elevation: 0,
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.more_vert_outlined, color: primary),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );
  }
}
