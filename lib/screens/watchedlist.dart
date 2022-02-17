import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/screens/home_screen.dart';
import 'package:movie_manager/widget/drawer_body.dart';
import 'package:movie_manager/widget/list.dart';
import 'package:movie_manager/widget/main_drawer.dart';
import 'package:movie_manager/widget/watched.dart';

class WatchededList extends StatefulWidget {
  const WatchededList({Key? key}) : super(key: key);

  @override
  State<WatchededList> createState() => _WatchededListState();
}

class _WatchededListState extends State<WatchededList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
         leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        centerTitle: true,
        title: Text('Your watched movies List'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('watchedposter').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(),
              child:WatchedCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
