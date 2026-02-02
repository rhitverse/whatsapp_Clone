class UserModel {
  final String displayname;
  final String uid;
  final String profilePic;
  final String? bio;
  final String? username;
  final List<String> groupId;

  UserModel({
    required this.displayname,
    required this.uid,
    required this.profilePic,
    this.bio,
    required this.groupId,
    this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayname': displayname,
      'uid': uid,
      'profilePic': profilePic,
      'bio': bio,
      'username': username,
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
      groupId: map['groupId'] != null ? List<String>.from(map['groupId']) : [],
    );
  }
}
