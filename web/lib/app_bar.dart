import 'package:flutter/material.dart';
import 'providers.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      title: Provider.of<BarProvider>(context).getAppBarTitle,
      leading: Provider.of<BarProvider>(context).getAppBarIconButton,
      centerTitle: true,
      elevation: 4,
    );
  }
}
