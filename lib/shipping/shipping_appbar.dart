import 'package:flutter/material.dart';
import 'package:shipbay/shared/services/colors.dart';

class ShippingAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  ShippingAppBar(
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
            icon: Icon(Icons.more_vert, color: primary),
            onPressed: () =>
                Navigator.pushNamed(context, '/about', arguments: 'shipping/'),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );
  }
}
