import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/attribute_value.dart';
import 'package:quotierte_redeliste/models/currently_speaking.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/ui/components/Utils.dart';

abstract class UserWidgetInteraction {
  void pause();
  void resume();
  void next();
}

class UserWidget extends StatefulWidget {
  final User user;
  final Function onTap;
  final CurrentlySpeaking currentlySpeaking;
  final UserWidgetInteraction userWidgetInteraction;

  UserWidget(this.user,
      {this.onTap, this.currentlySpeaking, this.userWidgetInteraction, Key key})
      : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  int duration;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _setupTimer();
  }

  @override
  void didUpdateWidget(UserWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setupTimer();
  }

  _setupTimer() {
    if (timer != null) timer.cancel();

    if (widget.currentlySpeaking != null) {
      duration = widget.currentlySpeaking.duration;

      if (widget.currentlySpeaking.running) {
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            duration += 1000;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: widget.currentlySpeaking != null
              ? Colors.black12
              : Colors.transparent,
          border: Border(
              bottom: BorderSide(color: Theme.of(context).disabledColor)),
        ),
        child: ListTile(
          onTap: widget.onTap,
          contentPadding: widget.currentlySpeaking == null
              ? EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0)
              : EdgeInsets.symmetric(horizontal: 12),
          title: _getTitleForUser(),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 10),
            child: widget.currentlySpeaking == null
                ? _getAttributeRow()
                : _getAttributeRowAndButtons(),
          ),
        ));
  }

  Widget _getTitleForUser() => widget.currentlySpeaking == null
      ? _getUsername()
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getUsername(),
            Text(Utils.getTimeStringFromSeconds(duration ~/ 1000))
          ],
        );

  Widget _getUsername() =>
      Text(widget.user.name, style: TextStyle(fontSize: 20.0));

  Widget _getAttributeRow() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: widget.user.attributes.map((attribute) {
        AttributeValue attributeValue = attribute.values[0];

        Color backgroundColor = attributeValue.color;
        Color fontColor = Utils.getFontColorForBackground(backgroundColor);

        return Padding(
            padding: EdgeInsets.only(right: 15),
            child: Chip(
                backgroundColor: backgroundColor,
                label: Text(attributeValue.value,
                    style: TextStyle(color: fontColor))));
      }).toList()));

  Widget _getAttributeRowAndButtons() =>
      Column(children: [_getAttributeRow(), _getButtonsForActualSpeaking()]);

  Widget _getButtonsForActualSpeaking() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        widget.currentlySpeaking.running ? _pauseButton() : _resumeButton(),
        _stopButton()
      ]);

  Widget _pauseButton() => RaisedButton(
      child: Icon(Icons.pause),
      onPressed: () {
        _setupTimer();
        widget.userWidgetInteraction.pause();
      });

  Widget _resumeButton() => RaisedButton(
      child: Icon(Icons.play_arrow),
      onPressed: () {
        _setupTimer();
        widget.userWidgetInteraction.resume();
      });

  Widget _stopButton() => RaisedButton(
      child: Icon(Icons.skip_next),
      onPressed: () => widget.userWidgetInteraction.next());
}
