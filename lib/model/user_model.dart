class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? fav;

  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.fav,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      fav: map['fav'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'fav': fav,
    };
  }
}
