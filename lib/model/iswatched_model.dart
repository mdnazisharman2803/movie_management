import 'package:cloud_firestore/cloud_firestore.dart';

class IsWatched {
  final String uid;
  final String title;
  final String diectorname;
  final bool watch;
  final String  watchedUrl;
  final String postId;

  const IsWatched({
    required this.uid,
    required this.title,
    required this.diectorname,
    required this.watch,
    required this. watchedUrl,
    required this.postId,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "title": title,
        "diectorname": diectorname,
        "watch": watch,
        'watchedUrl':  watchedUrl,
        "postId": postId,
      };

  static IsWatched fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return IsWatched(
      uid: snapshot["uid"],
      title: snapshot["title"],
      diectorname: snapshot["diectorname"],
      watch: snapshot["watch"],
      watchedUrl: snapshot['watchedUrl'],
      postId: snapshot['postId'],
    );
  }
}
