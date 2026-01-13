class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final bool isOnline;
  final String? phoneNumber;
  final List<String> groupId;


  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'profilePic': this.profilePic,
      'uid': this.uid,
      'isOnline': this.isOnline,
      'phoneNumber': this.phoneNumber,
      'groupId': this.groupId,

    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String?,
      groupId: List<String>.from(map['groupId'] ?? []),
    );
  }
}
