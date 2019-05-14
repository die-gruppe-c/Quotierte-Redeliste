import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quotierte_redeliste/models/attribute_value.dart';
import 'package:quotierte_redeliste/models/user.dart';

class UserWidget extends StatelessWidget {
  final User user;
  final Function onTap;

  UserWidget(this.user, {this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).disabledColor)),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          title: Text(
            user.name,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          subtitle: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: user.attributes.map((attribute) {
                  AttributeValue attributeValue = attribute.values[0];

                  return Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Chip(
                        avatar: Icon(MdiIcons.information),
                        label: Text(attributeValue.value),
                      ));
                  // TODO change to color from attribute
                }).toList(),
              )),
        ));
  }
}
