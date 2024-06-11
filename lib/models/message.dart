class Message {
  Message({
    required this.toId,
    required this.read,
    required this.type,
    required this.message,
    required this.fromId,
    required this.sent,
  });
  late final String toId;
  late final String read;
  late final Type type;
  late final String message;
  late final String fromId;
  late final String sent;

  Message.fromJson(Map<String, dynamic> json){
    toId = json['toId'].toString();
    read = json['read'].toString();
    type = json['type'].toString() ==  Type.image.name ? Type.image : Type.text;
    message = json['message'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['read'] = read;
    data['type'] = type.name;
    data['message'] = message;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}

enum Type{text, image}