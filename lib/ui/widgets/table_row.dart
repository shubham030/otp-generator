import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomTableRow extends StatefulWidget {
  final String id;
  final String email;
  final int otp;
  final DateTime timeStamp;

  const CustomTableRow({
    Key key,
    this.id,
    this.email,
    this.otp,
    this.timeStamp,
  }) : super(key: key);

  @override
  _CustomTableRowState createState() => _CustomTableRowState();
}

class _CustomTableRowState extends State<CustomTableRow> {
  Timer timer;
  int timeRemaining;

  @override
  void initState() {
    int timeInMilli = widget.timeStamp
        .add(
          Duration(
            minutes: 1,
          ),
        )
        .millisecondsSinceEpoch;
    timer = Timer.periodic(
      Duration(seconds: 1),
      (e) {
        timeRemaining = timeInMilli - DateTime.now().millisecondsSinceEpoch;
        if (timeRemaining > 0) {
          setState(() {});
        } else {
          Firestore.instance
              .collection('otp')
              .document(widget.id)
              .delete()
              .then(
                (_) => timer.cancel(),
              );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(), right: BorderSide(), bottom: BorderSide()),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1),
                ),
              ),
              child: Center(child: Text(widget.email)),
            ),
          ),
          Container(
            width: width * 0.2,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5),
                Text('Otp: ${widget.otp.toString()}'),
                Spacer(),
                Text(timeRemaining != null
                    ? 'time: ${timeRemaining ~/ 1000}'
                    : 'time: __'),
                SizedBox(height: 5),
              ],
            ),
          ),
          Container(
            width: width * 0.20,
            child: FlatButton(
              child: Text('Delete'),
              onPressed: () {
                Firestore.instance
                    .collection('otp')
                    .document(widget.id)
                    .delete();
              },
            ),
          ),
        ],
      ),
    );
  }
}
