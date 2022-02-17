import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_manager/model/iswatched_model.dart';

import 'package:movie_manager/model/movielist.dart';

import 'package:movie_manager/model/storage.dart';
import 'package:uuid/uuid.dart';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<String> uploadPoster(
    String uid,
    String title,
    String diectorname,
    Uint8List file,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
       
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('createdmovies', file, false);
      String postId = const Uuid().v1(); // creates unique id based on time
      Movie post = Movie(
        uid: uid,
        title: title,
        diectorname: diectorname,
        datePublished: DateTime.now(),
        posterUrl: photoUrl,
        postId: postId,
      );
      _firestore.collection('createdmovies').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Poster
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('createdmovies').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Add to watch list
  Future<String> addToWatch(
    String postId,
    String uid,
    bool isWatched,
    String title,
    String diectorname,
    String wtchuUrl

  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
     
      IsWatched done = IsWatched(
        uid: uid,
        title: title,
        diectorname: diectorname,
        watch: isWatched,
        watchedUrl: wtchuUrl,
        postId: postId,
      );
     await _firestore.collection('watchedposter').doc(postId).set(
            done.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }




  // Delete watched
  Future<String> deleteWatched(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('watchedposter').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

