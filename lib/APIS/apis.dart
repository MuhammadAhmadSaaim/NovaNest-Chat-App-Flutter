import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:novanest/models/message.dart';

import '../models/chat_user.dart';

class APIS {
  static late ChatUser me; //for storing self info

  static FirebaseAuth auth = FirebaseAuth.instance; //authentication

  static FirebaseFirestore firestore =
      FirebaseFirestore.instance; //firestore database connection

  static FirebaseStorage storage =
      FirebaseStorage.instance; //firebase storage connection

  static User get user => auth.currentUser!; //return current user

  //Checking if user exsists
  static Future<bool> userExsists() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  //for getting current user info
  static Future<void> getCurrentUserInfo() async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        createUser().then((value) => getCurrentUserInfo());
      }
    });
  }

  //creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        name: user.displayName.toString(),
        about: "Hey there, I'm using NovaNest",
        createdAt: time,
        isOnline: false,
        id: user.uid,
        lastActive: time,
        email: user.email.toString(),
        pushToken: '',
        image: user.photoURL.toString());
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //Get all users on the platform except the one currently signed in
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //updating user info
  static Future<void> updateUserInfo() async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('ProfilePictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});
    me.image = await ref.getDownloadURL();
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({'image': me.image});
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? "${user.uid}_$id"
      : "${id}_${user.uid}";

  //Get messages on the platform except the one currently signed in
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chat/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        toId: chatUser.id,
        read: "",
        type: Type.text,
        message: msg,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chat/${getConversationID(chatUser.id)}/messages/');
    ref.doc(time).set(message.toJson());
  }
}
