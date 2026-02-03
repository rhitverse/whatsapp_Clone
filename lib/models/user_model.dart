class UserModel {
  final String displayname;
  final String uid;
  final String profilePic;
  final String? bio;
  final String? username;
  final String? birthday;
  final List<String> groupId;

  UserModel({
    required this.displayname,
    required this.uid,
    required this.profilePic,
    this.bio,
    required this.groupId,
    this.username,
    this.birthday,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayname': displayname,
      'uid': uid,
      'profilePic': profilePic,
      'bio': bio,
      'username': username,
      'birthday': birthday,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayname: map['displayname'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      bio: map['bio'],
      username: map['username'],
      birthday: map['birthday'],
      groupId: map['groupId'] != null ? List<String>.from(map['groupId']) : [],
    );
  }
}
