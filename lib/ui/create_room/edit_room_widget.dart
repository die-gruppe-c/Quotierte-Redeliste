import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quotierte_redeliste/icons/custom_icons.dart';
import 'package:quotierte_redeliste/models/attribute.dart';
import 'package:quotierte_redeliste/models/attribute_value.dart';
import 'package:quotierte_redeliste/ui/create_room/create_room_bloc.dart';

class EditRoomWidget extends StatefulWidget {
  @override
  _EditRoomWidgetState createState() => _EditRoomWidgetState();

  EditRoomWidget({Key key}) : super(key: key);
}

class _EditRoomWidgetState extends State<EditRoomWidget> {
  static const double PADDING_SIDE = 16;
  static const int ADD_ATTRIBUTE_ANIM_DURATION = 300;
  static const int REMOVE_ATTRIBUTE_ANIM_DURATION = 400;

  final GlobalKey<AnimatedListState> _attrListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      key: _attrListKey,
      initialItemCount: createRoomBloc.getAttributeCount(),
      itemBuilder: (BuildContext context, int index, Animation animation) {
        return FadeTransition(
          opacity: animation,
          child: _buildAttributeListItem(
              createRoomBloc.getAttribute(index), index),
        );
      },
    );
  }

  _buildAttributeListItem(Attribute attribute, [int attrIdx]) {
    var icon = Icons.label_outline;

    if (attrIdx != null &&
        (attrIdx != createRoomBloc.getAttributeCount() - 1 ||
            attribute.name.length != 0)) {
      icon = Icons.label;
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
                Container(
                  child: attribute.values.length <= 2
                      ? null
                      : IconButton(
                          icon: Icon(CustomIcons.weight_balance),
                          onPressed: () {
                            setState(() {
                              attribute.addWeights();
                            });
                            showDialog(
                                    context: context,
                                    builder: (_) => WeightPickerDialog(
                                        attribute: attribute))
                                .then((_) => setState(() {}));
                          },
                        ),
                ),
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
    var icon = Icons.fiber_manual_record;
    //var iconColor = Theme.of(context).hintColor;
    var iconColor = attribute.values[valueIdx].color;

    var newValueMode = valueIdx == attribute.values.length - 1 &&
        attribute.values[valueIdx].value.length == 0;

    if (newValueMode) {
      icon = MdiIcons.menuRightOutline;
      iconColor = Theme.of(context).hintColor;
    }

    bool allNull = true;

    attribute.values.forEach((value) {
      if (value.weight != 0) allNull = false;
    });

    return Container(
        child: Container(
      padding: const EdgeInsets.only(left: 40, right: 12),
      child: Row(
        children: <Widget>[
          Center(
            child: Container(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(
                    icon,
                    color: iconColor,
                  ),
                  onPressed: newValueMode
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                    title: new Text("Farbe wählen"),
                                    content: MaterialColorPicker(
                                      onColorChange: (Color color) {
                                        setState(() {
                                          attribute.values[valueIdx].color =
                                              color;
                                        });
                                      },
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: new Text(
                                            'OK',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).accentColor),
                                          ))
                                    ],
                                  ));
                        },
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
          Text(newValueMode || allNull
              ? ""
              : "${attribute.values[valueIdx].weight}%"),
        ],
      ),
    ));
  }

  addAttribute() {
    int index = createRoomBloc.getAttributeCount();

    var newAttribute = new Attribute("");
    newAttribute.name = "";
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

class WeightPickerDialog extends StatefulWidget {
  final attribute;

  const WeightPickerDialog({Key key, this.attribute}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeightPickerDialogState();
}

class WeightPickerDialogState extends State<WeightPickerDialog> {
  Attribute attribute;

  @override
  void initState() {
    super.initState();
    this.attribute = widget.attribute;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Wähle Gewichtungen"),
      content: Container(
        width: 300,
        child: Column(children: [
          Expanded(
              child: ListView.separated(
            itemBuilder: (context, position) {
              return _buildValueWeightSelectorItem(context, position);
            },
            itemCount: this.attribute.values.length - 1,
            separatorBuilder: (context, index) => Divider(),
          )),
        ]),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              setState(() {
                for (var value in this.attribute.values) {
                  value.weight = 0;
                }
              });
              Navigator.of(context).pop();
            },
            child: new Text(
              'ALLE ENTFERNEN',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
            )),
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
            )),
      ],
    );
  }

  _buildValueWeightSelectorItem(BuildContext context, int valueIdx) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            attribute.values[valueIdx].value,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Slider(
                  value: attribute.values[valueIdx].weight.toDouble(),
                  min: 0.0,
                  max: 100.0,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (weight) {
                    setState(() {
                      this.attribute.setWeight(weight.toInt(), valueIdx);
                    });
                  },
                ),
              ),
              Text("${attribute.values[valueIdx].weight}%")
            ],
          )
        ],
      ),
    );
  }
}

typedef ScrollListener = void Function(double, double, bool);
