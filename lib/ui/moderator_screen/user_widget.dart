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
  final String speechCategory;

  UserWidget(this.user,
      {this.speechCategory = "",
      this.onTap,
      this.currentlySpeaking,
      this.userWidgetInteraction,
      Key key})
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

    bool sameUser =
        oldWidget.user != null && oldWidget.user.id == widget.user.id;

    if (sameUser &&
        oldWidget != null &&
        oldWidget.currentlySpeaking != null &&
        oldWidget.currentlySpeaking.duration ==
            widget.currentlySpeaking.duration) {
      _setupTimer(resetTimer: false);
    } else {
      _setupTimer();
    }
  }

  _setupTimer({resetTimer: true}) {
    if ((resetTimer || duration == null) && widget.currentlySpeaking != null)
      duration = widget.currentlySpeaking.duration;

    if (timer != null) {
      if (widget.currentlySpeaking == null ||
          !widget.currentlySpeaking.running) {
        timer.cancel();
      } else if (widget.currentlySpeaking != null &&
          widget.currentlySpeaking.running) {
        if (!timer.isActive) timer = _createTimer();
      }
    } else if (widget.currentlySpeaking != null &&
        widget.currentlySpeaking.running) {
      timer = _createTimer();
    }
  }

  Timer _createTimer() {
    return Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        duration += 500;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: widget.currentlySpeaking != null
              ? Color(0x08000000)
              : Colors.transparent,
          border: Border(
              bottom: BorderSide(color: Theme.of(context).disabledColor)),
        ),
        child: ListTile(
          onTap: widget.onTap,
          contentPadding: widget.currentlySpeaking == null
              ? EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0)
              : EdgeInsets.symmetric(horizontal: 8),
          title: Container(
              padding: EdgeInsets.only(top: 8), child: _getUsername()),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 2, bottom: 4),
            child: widget.currentlySpeaking == null
                ? _getAttributeRow()
                : _getAttributeRowAndButtons(),
          ),
        ));
  }

  Widget _getUsername() {
    var style = Theme.of(context).textTheme.title;

    if (widget.currentlySpeaking != null) {
      style = Theme.of(context).textTheme.headline;
    }

    var tvName = Text(widget.user.name, style: style);

    if (widget.user.createdByOwner)
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[tvName, Text(widget.speechCategory)],
      );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(children: [
          Container(
              padding: EdgeInsets.only(right: 8), child: Icon(Icons.person)),
          tvName
        ]),
        Text(widget.speechCategory)
      ],
    );
  }

  Widget _getAttributeRow() => SingleChildScrollView(
      padding: widget.currentlySpeaking == null
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: widget.user.attributes.map((attribute) {
        AttributeValue attributeValue = attribute.values[0];

        Color backgroundColor = attributeValue.color;
        Color fontColor = Utils.getFontColorForBackground(backgroundColor);

        return Padding(
            padding: EdgeInsets.only(right: 12),
            child: Chip(
                backgroundColor: backgroundColor,
                label: Text(attributeValue.value,
                    style: TextStyle(color: fontColor, fontSize: 14))));
      }).toList()));

  Widget _getAttributeRowAndButtons() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_getAttributeRow(), _getButtonsForActualSpeaking()]);

  Widget _getButtonsForActualSpeaking() => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 22, right: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: EdgeInsets.only(right: 8),
                        child: widget.currentlySpeaking.running
                            ? _pauseButton()
                            : _resumeButton()),
                    Container(
                        padding: EdgeInsets.only(left: 8),
                        child: _stopButton()),
                  ]),
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  Utils.getTimeStringFromSeconds(duration ~/ 1000),
                  style: Theme.of(context).textTheme.headline,
                ),
              )
            ],
          ),
        ),
      );

  Widget _pauseButton() => IconButton(
      icon: Icon(Icons.pause),
      color: Theme.of(context).primaryColorDark,
      onPressed: () {
        widget.userWidgetInteraction.pause();
      });

  Widget _resumeButton() => IconButton(
      icon: Icon(Icons.play_arrow),
      color: Theme.of(context).primaryColorDark,
      onPressed: () {
        widget.userWidgetInteraction.resume();
      });

  Widget _stopButton() => IconButton(
      icon: Icon(Icons.skip_next),
      color: Theme.of(context).primaryColorDark,
      onPressed: () => widget.userWidgetInteraction.next());
}
