import 'package:flutter/material.dart';

class FunkyNotification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyNotificationState();
}

class FunkyNotificationState extends State<FunkyNotification>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: SlideTransition(
              position: position,
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Notification!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}