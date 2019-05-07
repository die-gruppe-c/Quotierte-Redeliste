import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotierte_redeliste/models/attribute.dart';
import 'package:quotierte_redeliste/models/attribute_value.dart';
import 'package:quotierte_redeliste/ui/create_room/create_room_bloc.dart';

class EditRoomWidget extends StatefulWidget {
  var _scrollListener;

  @override
  _EditRoomWidgetState createState() => _EditRoomWidgetState(_scrollListener);

  EditRoomWidget({scrollListener}) {
    this._scrollListener = scrollListener;
  }
}

class _EditRoomWidgetState extends State<EditRoomWidget> {
  static const double PADDING_SIDE = 16;
  static const int ADD_ATTRIBUTE_ANIM_DURATION = 300;
  static const int REMOVE_ATTRIBUTE_ANIM_DURATION = 400;

  final GlobalKey<AnimatedListState> _attrListKey = GlobalKey();

  ScrollController _scrollcontroller;

  var _scrollListener;

  _EditRoomWidgetState(this._scrollListener);

  @override
  void initState() {
    _scrollcontroller = ScrollController();
    _scrollcontroller.addListener(scrollListener);
  }

  scrollListener() {
    if (_scrollListener != null) {
      _scrollListener(
          _scrollcontroller.offset,
          _scrollcontroller.position.minScrollExtent,
          _scrollcontroller.position.outOfRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: AnimatedList(
      key: _attrListKey,
      controller: _scrollcontroller,
      initialItemCount: createRoomBloc.getAttributeCount(),
      itemBuilder: (BuildContext context, int index, Animation animation) {
        return FadeTransition(
          opacity: animation,
          child: _buildAttributeListItem(
              createRoomBloc.getAttribute(index), index),
        );
      },
    ));
  }

  _buildAttributeListItem(Attribute attribute, [int attrIdx]) {
    var icon = Icons.add;

    if (attrIdx != null &&
        (attrIdx != createRoomBloc.getAttributeCount() - 1 ||
            attribute.name.length != 0)) {
      icon = Icons.category;
    }

    return Container(
        key: ObjectKey(attribute),
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: PADDING_SIDE, right: PADDING_SIDE),
                      child: Icon(
                        icon,
                      )),
                ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(right: PADDING_SIDE),
                        child: TextField(
                          controller: new TextEditingController.fromValue(
                              new TextEditingValue(
                                  text: attribute.name,
                                  selection: new TextSelection.collapsed(
                                      offset: attribute.name.length))),
                          cursorColor: Theme.of(context).hintColor,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Attribut hinzufügen",
                              hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor)),
                          onChanged: (text) {
                            attribute.name = text;
                            if (attrIdx != null) {
                              if (attrIdx ==
                                      createRoomBloc.getAttributeCount() - 1 &&
                                  text.length > 0) {
                                addAttribute();
                              } else if (attrIdx ==
                                      createRoomBloc.getAttributeCount() - 2 &&
                                  text.length == 0 &&
                                  createRoomBloc
                                          .getAttribute(createRoomBloc
                                                  .getAttributeCount() -
                                              1)
                                          .name ==
                                      "") {
                                removeAttribute(
                                    createRoomBloc.getAttributeCount() - 1);
                              }
                            }
                          },
                          onEditingComplete: () {
                            if (attrIdx <
                                    createRoomBloc.getAttributeCount() - 2 &&
                                attribute.name == "") {
                              removeAttribute(attrIdx);
                            }
                          },
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
            ListView.builder(
              itemBuilder: (context, position) {
                return _buildAttributeValueListItem(
                    context, attribute, position);
              },
              itemCount: attribute.values.length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
            Divider(),
          ],
        ));
  }

  _buildAttributeValueListItem(
      BuildContext context, Attribute attribute, int valueIdx) {
    var icon = Icons.arrow_right;
    var iconColor = Theme.of(context).primaryColorDark;

    if (valueIdx == attribute.values.length - 1 &&
        attribute.values[valueIdx].value.length == 0) {
      icon = Icons.add;
      iconColor = Theme.of(context).hintColor;
    }

    return Container(
      child: Row(
        children: <Widget>[
          Center(
            child: Container(
                padding: const EdgeInsets.only(left: 56, right: 4),
                child: Icon(
                  icon,
                  color: iconColor,
                )),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(right: PADDING_SIDE),
                  child: TextField(
                    controller: new TextEditingController.fromValue(
                        new TextEditingValue(
                            text: attribute.values[valueIdx].value,
                            selection: new TextSelection.collapsed(
                                offset:
                                    attribute.values[valueIdx].value.length))),
                    cursorColor: Theme.of(context).hintColor,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Wert hinzufügen",
                        hintStyle:
                            TextStyle(color: Theme.of(context).hintColor)),
                    onChanged: (text) {
                      attribute.values[valueIdx].value = text;
                      setState(() {
                        if (valueIdx == attribute.values.length - 1 &&
                            text.length > 0) {
                          attribute.values.add(AttributeValue(""));
                        } else if (valueIdx == attribute.values.length - 2 &&
                            text.length == 0 &&
                            attribute.values[attribute.values.length - 1]
                                    .value ==
                                "") {
                          attribute.values.removeLast();
                        }
                      });
                    },
                    onEditingComplete: () {
                      if (valueIdx < attribute.values.length - 2 &&
                          attribute.values[valueIdx].value == "") {
                        setState(() {
                          attribute.values.removeAt(valueIdx);
                        });
                      }
                    },
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ))),
        ],
      ),
    );
  }

  addAttribute() {
    int index = createRoomBloc.getAttributeCount();

    var newAttribute = new Attribute("");
    newAttribute.values.add(AttributeValue(""));

    createRoomBloc.addAttribute(newAttribute);

    _attrListKey.currentState.insertItem(index,
        duration: Duration(milliseconds: ADD_ATTRIBUTE_ANIM_DURATION));
  }

  removeAttribute(int index) {
    var attribute = createRoomBloc.removeAttribute(index);
    _attrListKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
            opacity:
                CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
            child: _buildAttributeListItem(attribute));
      },
      duration: Duration(milliseconds: REMOVE_ATTRIBUTE_ANIM_DURATION),
    );
  }
}
