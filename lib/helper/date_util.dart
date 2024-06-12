import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time,bool showYear =false}) {
    final DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime currTime = DateTime.now();

    if (currTime.day == sentTime.day &&
        currTime.month == sentTime.month &&
        currTime.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }

    return showYear?"${sentTime.day} ${_getMonth(sentTime)} ${sentTime.year}":"${sentTime.day} ${_getMonth(sentTime)}";
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return "NA";
  }

  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;
    if (i == -1) return "Last seen not available";
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return "Last seen today at $formattedTime";
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen yesterday at $formattedTime";
    }

    String month = _getMonth(time);
    return "Last seen on ${time.day} $month at $formattedTime";
  }
}
