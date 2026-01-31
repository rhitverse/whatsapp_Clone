class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final String username;
  final List<String> groupId;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.username,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'username': username,
      'group': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      username: map['username'] ?? '',
      groupId: map['groupId'] != null ? List<String>.from(map['groupId']) : [],
    );
  }
}
