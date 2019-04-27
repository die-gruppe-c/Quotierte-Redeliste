import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/display_room/display_room_bloc.dart';

class DisplayRoomScreen extends StatefulWidget {
  int _id;

  DisplayRoomScreen({Key key, @required int roomId}) : super(key: key) {
    this._id = roomId;
  }

  @override
  _DisplayRoomScreenState createState() => _DisplayRoomScreenState(_id);
}

class _DisplayRoomScreenState extends State<DisplayRoomScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const double PADDING_SIDE = 16;

  bool _stateRoomLoaded = false;
  bool _stateError = false;

  int _id;

  _DisplayRoomScreenState(int id) {
    _id = id;
    displayRoomBloc.loadRoom(id, onRoomLoaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        actions: <Widget>[],
        bottom: NameDisplayContainer(
            alignment: Alignment(-1.0, 0.0),
            padding: const EdgeInsets.only(left: 56, right: PADDING_SIDE),
            child: Text(_stateRoomLoaded ? displayRoomBloc.getName() : "",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.normal))),
      ),
      // body is the majority of the screen.
      body: _stateError
          ? null
          : Center(
              child: _stateRoomLoaded ? null : CircularProgressIndicator(),
            ),
    );
  }

  onRoomLoaded({String error}) {
    if (error != null) {
      final snackBar = SnackBar(
        content: Row(
          children: <Widget>[
            Icon(Icons.error),
            Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text(error),
            )
          ],
        ),
        action: SnackBarAction(
          label: 'RETRY',
          onPressed: () {
            displayRoomBloc.loadRoom(_id, onRoomLoaded);
            setState(() {
              _stateError = false;
            });
          },
        ),
        duration: Duration(hours: 1),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        _stateError = true;
      });

      return;
    }
    setState(() {
      _stateRoomLoaded = true;
    });
  }
}

class NameDisplayContainer extends Container implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56);

  NameDisplayContainer({alignment, padding, child})
      : super(child: child, alignment: alignment, padding: padding);
}
