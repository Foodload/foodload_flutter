class User {
  String token;
  String email;
  int familyId;
  String familyName;

  User({this.familyName, this.token, this.email, this.familyId});

  @override
  String toString() {
    return 'User: { token: $token, email: $email, familyId: $familyId, familyName: $familyName }';
  }

  User copyWith({String token, String email, int familyId, String familyName}) {
    return User(
      token: token ?? this.token,
      email: email ?? this.email,
      familyId: familyId ?? this.familyId,
      familyName: familyName ?? this.familyName,
    );
  }

  User.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        email = json['client']['email'],
        familyId = json['client']['family']['id'],
        familyName = json['client']['family']['name'];
}
