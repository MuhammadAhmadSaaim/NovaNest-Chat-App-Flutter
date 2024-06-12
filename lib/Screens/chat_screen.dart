import 'dart:io';

import 'package:flutter/foundation.dart' as foundation;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novanest/Screens/view_profile_screen.dart';
import 'package:novanest/helper/date_util.dart';
import 'package:novanest/models/chat_user.dart';
import '../APIS/apis.dart';
import '../Widgets/message_card.dart';
import '../main.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];
  final textController = TextEditingController();

  bool showEmoji = false;

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (showEmoji) {
            setState(() {
              showEmoji = !showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          backgroundColor: Colors.teal.shade50,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIS.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: SizedBox(),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                              [];

                          if (list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: list[index],
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "Say Hi",
                                style: TextStyle(fontSize: 30),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))),
                _chatInput(),
                if (showEmoji)
                  EmojiPicker(
                    textEditingController: textController,
                    // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      height: mq.height * .35,
                      emojiViewConfig: EmojiViewConfig(
                        columns: 8,
                        emojiSizeMax: 28 *
                            (foundation.defaultTargetPlatform ==
                                TargetPlatform.iOS
                                ? 1.20
                                : 1.0),
                      ),
                      bottomActionBarConfig: const BottomActionBarConfig(
                          backgroundColor: Colors.teal,
                          buttonColor: Colors.teal),
                      searchViewConfig: const SearchViewConfig(
                          backgroundColor: Colors.teal,
                          buttonColor: Colors.white,
                          buttonIconColor: Colors.white),
                      categoryViewConfig: const CategoryViewConfig(
                          indicatorColor: Colors.teal,
                          iconColorSelected: Colors.teal),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream:APIS.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                        width: mq.height * .04,
                        height: mq.height * .04,
                        imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list.isNotEmpty ? list[0].name :widget.user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            list.isNotEmpty ?
                            list[0].isOnline? "Online" :
                            DateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                                :DateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        )
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          showEmoji = !showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.black54,
                      )),
                  Expanded(
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          setState(() {
                            if (showEmoji) {
                              showEmoji = !showEmoji;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);

                        for (var i in images) {
                          setState(() {
                            isUploading = true;
                          });
                          await APIS.sendChatImage(widget.user, File(i.path));
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.image_outlined,
                        color: Colors.black54,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          setState(() {
                            isUploading = true;
                          });
                          await APIS.sendChatImage(
                              widget.user, File(image.path));
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.black54,
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                APIS.sendMessage(widget.user, textController.text, Type.text);
                textController.text = "";
              }
            },
            minWidth: 10,
            padding: const EdgeInsets.all(10),
            shape: const CircleBorder(),
            color: Colors.teal,
            child: const Icon(
              Icons.send_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
