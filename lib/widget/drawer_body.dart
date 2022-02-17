import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/screens/createdmovies_listscreen.dart';
import 'package:movie_manager/screens/login_screen.dart';
import 'package:movie_manager/screens/watchedlist.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.format_list_bulleted_rounded,
              color: Colors.red,
            ),
            title: Text(
              'Created List',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            onTap:(){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CreatedList())
              );
            }
          ),
           ListTile(
            leading: Icon(
              Icons.sentiment_satisfied_alt_outlined,
              color: Colors.red,
            ),
            title: Text(
              'Watched',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            onTap:(){
               Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  WatchededList())
               );
            }
          ),
           ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            onTap:(){
              logout(context);
            }
          )
        ],
      ),
    ); 
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
