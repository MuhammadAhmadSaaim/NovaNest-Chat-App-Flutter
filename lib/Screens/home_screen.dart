import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novanest/Screens/profile_screen.dart';
import 'package:novanest/Widgets/user_chat_card.dart';
import '../APIS/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> searchList = [];
  bool isSearching = false;

  @override
  void initState() {
    APIS.getCurrentUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(isSearching){
            setState(() {
              isSearching =!isSearching ;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: isSearching ? TextField(
              onChanged: (val){
                searchList.clear();
                for(var i in list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                    searchList.add(i);
                  }
                  setState(() {
                    searchList;
                  });
                }
              },
              autofocus: true,
              style: TextStyle(fontSize: 17,letterSpacing: 0.9),
              decoration: InputDecoration(
                border: InputBorder.none, hintText: "Name | Email",
              ),
            ) : const Text("NovaNest"),
            //leading: const Icon(CupertinoIcons.home),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                  icon: Icon(isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search_rounded)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIS.me),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert_rounded)),
            ],
          ),
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10),
              child: FloatingActionButton(
                onPressed: () async {
                  await APIS.auth.signOut();
                  await GoogleSignIn().signOut();
                },
                child: const Icon(Icons.add_comment_rounded),
              )),
          body: StreamBuilder(
            stream: APIS.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                  if (list.isNotEmpty) {
                    return ListView.builder(
                        itemCount: isSearching? searchList.length : list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(user: isSearching ? searchList[index] : list[index]);
                        });
                  } else {
                    return const Center(
                      child: Text("No Messages Found!"),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
