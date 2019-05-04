import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';

class UserWidget extends StatelessWidget {
  final User user;
  final Function onTap;

  UserWidget(this.user, {this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      title: Text(
        user.name,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      subtitle: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: user.attributes.values.map((attribute) {
              return Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Container(
                      // TODO change to color from attribute
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: EdgeInsets.all(5),
                      child: Text(attribute)));
            }).toList(),
          )),
    );
  }
}
