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
              ? Color(0x08000000)
              : Colors.transparent,
          border: Border(
              bottom: BorderSide(color: Theme.of(context).disabledColor)),
        ),
        child: ListTile(
          onTap: widget.onTap,
          contentPadding: widget.currentlySpeaking == null
              ? EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0)
              : EdgeInsets.symmetric(horizontal: 4),
          title: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: _getUsername()
                ),
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
    var align = TextAlign.start;

    if (widget.currentlySpeaking != null) {
      style = Theme.of(context).textTheme.headline;
      align = TextAlign.center;
    }

    var tvName = Text(widget.user.name, style: style, textAlign: align,);

    if (widget.user.createdByOwner) return tvName;

    return Row(
      children: <Widget>[
        Container( padding: EdgeInsets.only(right: 8), child: Icon(Icons.person)),
        tvName
      ],
    );
  }

  Widget _getAttributeRow() => SingleChildScrollView(
      padding: widget.currentlySpeaking == null ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 8),
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

  Widget _getAttributeRowAndButtons() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_getAttributeRow(), _getButtonsForActualSpeaking()]);

  Widget _getButtonsForActualSpeaking() =>

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Container(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 22, right: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                      Container(padding: EdgeInsets.only(right: 8),child: widget.currentlySpeaking.running ? _pauseButton() : _resumeButton()),
                      Container(padding: EdgeInsets.only(left: 8),child: _stopButton()),
                    ]),
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(Utils.getTimeStringFromSeconds(duration ~/ 1000),
                        style: Theme.of(context).textTheme.headline,),
                    )
                  ],
                ),

                ),
          )
      ;

  Widget _pauseButton() => IconButton(
      icon: Icon(Icons.pause),
      color: Theme.of(context).primaryColorDark,
      onPressed: () {
        _setupTimer();
        widget.userWidgetInteraction.pause();
      });

  Widget _resumeButton() => IconButton(
      icon: Icon(Icons.play_arrow),
      color: Theme.of(context).primaryColorDark,
      onPressed: () {
        _setupTimer();
        widget.userWidgetInteraction.resume();
      });

  Widget _stopButton() => IconButton(
      icon: Icon(Icons.skip_next),
      color: Theme.of(context).primaryColorDark,
      onPressed: () => widget.userWidgetInteraction.next());
}
