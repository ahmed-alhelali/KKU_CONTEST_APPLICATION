class UserModel {
  String displayName;
  String email;
  String id;
  String photoUrl;

  UserModel({this.displayName, this.email, this.photoUrl, this.id});

  UserModel.fromJson (Map<String, dynamic> json){
    this.displayName = json["name"];
    this.id = json["id"];
    this.email = json["email"];
    this.photoUrl = json["imageUrl"];
  }


}
