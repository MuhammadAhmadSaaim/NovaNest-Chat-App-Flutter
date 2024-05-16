class ChatUser {
  ChatUser({
    required this.name,
    required this.about,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.image,
  });
  late String name;
  late String about;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late String image;

  ChatUser.fromJson(Map<String, dynamic> json){
    name = json['name'] ?? "";
    about = json['about'] ?? "";
    createdAt = json['created_at'] ?? "";
    isOnline = json['is_online'] ?? "";
    id = json['id'] ?? "";
    lastActive = json['last_active'] ?? "";
    email = json['email'] ?? "";
    pushToken = json['push_token'] ?? "";
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['image'] = image;
    return data;
  }
}