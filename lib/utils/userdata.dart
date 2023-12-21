class User {
  String? userName;
  String? photoUrl;
  String? role;
  User({this.photoUrl, this.userName, this.role});
}

class Data{
  static final users = <User>[
    User(
        userName: "Sindhu",
        role: "Admin",
        photoUrl: "assets/images/sindu.png"
    ),
  ];
}