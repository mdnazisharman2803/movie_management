import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String uid;
  final String title;
  final String diectorname;
  final DateTime datePublished;
  final String posterUrl;
  final String postId;

  const Movie({
    required this.uid,
    required this.title,
    required this.diectorname,
    required this.datePublished,
    required this.posterUrl,
    required this.postId,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "title": title,
        "diectorname": diectorname,
        "datePublished": datePublished,
        'posterUrl': posterUrl,
        "postId": postId,
      };

  static Movie fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Movie(
      uid: snapshot["uid"],
      title: snapshot["title"],
      diectorname: snapshot["diectorname"],
      datePublished: snapshot["datePublished"],
      posterUrl: snapshot['posterUrl'],
      postId: snapshot['postId'],
    );
  }
}
