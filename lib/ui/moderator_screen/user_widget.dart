import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/attribute_value.dart';
import 'package:quotierte_redeliste/models/currently_speaking.dart';
import 'package:quotierte_redeliste/models/user.dart';

abstract class UserWidgetInteraction {
  void pause();
  void resume();
  void next();
}

class UserWidget extends StatelessWidget {
  final User user;
  final Function onTap;
  final CurrentlySpeaking currentlySpeaking;
  final UserWidgetInteraction userWidgetInteraction;

  UserWidget(this.user,
      {this.onTap, this.currentlySpeaking, this.userWidgetInteraction, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color:
              currentlySpeaking != null ? Colors.black12 : Colors.transparent,
          border: Border(
              bottom: BorderSide(color: Theme.of(context).disabledColor)),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: currentlySpeaking == null
              ? EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0)
              : EdgeInsets.symmetric(horizontal: 12),
          title: _getTitleForUser(),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 10),
            child: currentlySpeaking == null
                ? _getAttributeRow()
                : _getAttributeRowAndButtons(),
          ),
        ));
  }

  Widget _getTitleForUser() => currentlySpeaking == null
      ? _getUsername()
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getUsername(),
            Text((currentlySpeaking.duration ~/ 1000).toString())
          ],
        );

  Widget _getUsername() => Text(user.name, style: TextStyle(fontSize: 20.0));

  Widget _getAttributeRow() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: user.attributes.map((attribute) {
        AttributeValue attributeValue = attribute.values[0];

        Color backgroundColor = attributeValue.color;
        Color fontColor = _getFontColorForBackground(backgroundColor);

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
        currentlySpeaking.running ? _pauseButton() : _resumeButton(),
        _stopButton()
      ]);

  Widget _pauseButton() => RaisedButton(
      child: Icon(Icons.pause), onPressed: () => userWidgetInteraction.pause());

  Widget _resumeButton() => RaisedButton(
      child: Icon(Icons.play_arrow),
      onPressed: () => userWidgetInteraction.resume());

  Widget _stopButton() => RaisedButton(
      child: Icon(Icons.skip_next),
      onPressed: () => userWidgetInteraction.next());

  Color _getFontColorForBackground(Color background) {
    final int maxBrightness = 255 + 500 + 255;
    double brightness =
        background.red + background.green * 2.5 + background.blue;

    if (brightness < maxBrightness / 2) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
