import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:novanest/APIS/apis.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: mq.height * .005),
            padding: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: mq.width * .02),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              widget.message.message ,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: mq.width * .02,right: mq.width*.02), // Adding some margin for spacing
          child: Text(
            widget.message.sent,
            style: TextStyle(fontSize: 9, color: Colors.black54),
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
          margin: EdgeInsets.only(left: mq.width * .02,right: mq.width*.02), // Adding some margin for spacing
          child: Row(
            children: [
              Icon(Icons.done_all_rounded, color: Colors.lightBlueAccent,size: 15,),
              SizedBox(width: 5,),
              Text(
                widget.message.read+"12:00 PM",
                style: TextStyle(fontSize: 9, color: Colors.black54),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: mq.height * .005),
            padding: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: mq.width * .02),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Text(
              widget.message.message ,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

}
