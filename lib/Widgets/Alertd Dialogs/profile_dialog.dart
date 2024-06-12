import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:novanest/models/chat_user.dart';

import '../../Screens/view_profile_screen.dart';
import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  final ChatUser user;

  const ProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: mq.width * .6,
          child: Column(
            children: [
              Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  height: mq.height * .2,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  //placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_rounded)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> ViewProfileScreen(user: user)));
                    }, icon: Icon(Icons.info_outline_rounded)),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
