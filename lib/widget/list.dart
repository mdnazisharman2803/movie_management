import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_manager/model/firestore.dart';

import 'package:movie_manager/model/user_model.dart';

class MovieCard extends StatefulWidget {
  final snap;
  const MovieCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  get style => null;
  bool iswatched = false;
  Uint8List? _file;
  showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void addToWatchMovie(
    uid,
    iswatched,
 
  ) async {
    try {
      // upload to storage and db
      String res = await FireStoreMethods().addToWatch(
        widget.snap['postId'].toString(),
        uid,
        iswatched,
        widget.snap['title'].toString(),
        widget.snap['diectorname'].toString(),
         widget.snap['posterUrl'].toString(),
      );
      if (res == "success") {
        setState(() {
          iswatched = true;
        });
        showSnackBar(
          context,
          'Added To Watched List',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        iswatched = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 14,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Poster SECTION

                Container(
                  width: 160.0,
                  height: 160.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image.network(
     widget.snap['posterUrl'],
                      fit: BoxFit.cover,
                     
                    ),
                  ),
                ),

                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Text(
                            widget.snap['title'].toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Director Name : ',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                widget.snap['diectorname'].toString(),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) {
                  return Dialog(
                    child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          'Add To Watched List',
                        ]
                            .map(
                              (e) => InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                  onTap: () {
                                    addToWatchMovie(
                                      '${loggedInUser.uid}',
                                      iswatched,
                                   
                                    );
                                    // remove the dialog box
                                    Navigator.of(context).pop();
                                  }),
                            )
                            .toList()),
                  );
                },
              );
            },
            icon: const Icon(Icons.add_task),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) {
                  return Dialog(
                    child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          'Delete',
                        ]
                            .map(
                              (e) => InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                  onTap: () {
                                    deletePost(
                                      widget.snap['postId'].toString(),
                                    );
                                    // remove the dialog box
                                    Navigator.of(context).pop();
                                  }),
                            )
                            .toList()),
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
