import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:novanest/APIS/apis.dart';

import '../helper/date_util.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIS.user.uid == widget.message.fromId
        ? _senderMessage()
        : _receiverMessage();
  }

  Widget _receiverMessage() {
    if (widget.message.read.isEmpty) {
      APIS.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .005),
            padding: EdgeInsets.all(
                widget.message.type == Type.image ? 0 : mq.width * .02),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.message,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .3),
                    child: CachedNetworkImage(
                      width: mq.height * .04,
                      height: mq.height * .04,
                      imageUrl: widget.message.message,
                      placeholder: (context, url) =>
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: mq.width * .02, right: mq.width * .02),
          // Adding some margin for spacing
          child: Text(
            DateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 9, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _senderMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(left: mq.width * .02, right: mq.width * .02),
          padding: EdgeInsets.all(
              widget.message.type == Type.image ? 0 : mq.width * .02),
          child: Row(
            children: [
              if (widget.message.read.isNotEmpty)
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.lightBlueAccent,
                  size: 15,
                ),
              const SizedBox(
                width: 5,
              ),
              Text(
                DateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 9, color: Colors.black54),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .005),
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.width * .02),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.message,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.message,
                      placeholder: (context, url) =>
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                          ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
