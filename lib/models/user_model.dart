class UserModel {
  final String displayname;
  final String uid;
  final String profilePic;
  final String? bio;
  final String? username;
  final String? birthday;
  final List<String> groupId;
  final String? publicKey;

  final bool showBirthday;
  final bool showBirthYear;

  UserModel({
    required this.displayname,
    required this.uid,
    required this.profilePic,
    this.bio,
    required this.groupId,
    this.username,
    this.birthday,
    this.publicKey,

    required this.showBirthday,
    required this.showBirthYear,
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
      'publicKey': publicKey,
      'showBirthday': showBirthday,
      'showBirthYear': showBirthYear,
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
      publicKey: map['publicKey'],
      showBirthday: map['showBirthday'] ?? true,
      showBirthYear: map['showBirthYear'] ?? true,
    );
  }
}
