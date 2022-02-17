import 'package:flutter/material.dart';
import 'package:movie_manager/widget/drawer_body.dart';
import 'package:movie_manager/widget/drawer_header.dart';
class MainDrawer extends StatelessWidget {
  const MainDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Drawer(
        child: Column(
          children: [
            MyHeaderDrawer(),
            DrawerBody(),
          ],
        ),
      );
  }
}