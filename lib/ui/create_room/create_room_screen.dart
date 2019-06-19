import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotierte_redeliste/models/attribute.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/ui/components/ResponsiveContainer.dart';
import 'package:quotierte_redeliste/ui/create_room/create_room_bloc.dart';
import 'package:quotierte_redeliste/ui/create_room/edit_room_widget.dart';
import 'package:quotierte_redeliste/ui/waiting_room/waiting_room_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  CreateRoomScreen({Key key}) : super(key: key);

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const double PADDING_SIDE = 16;

  bool appBarElevated = false;

  bool createRequestSend = false;

  @override
  void initState() {
    super.initState();
    createRoomBloc.createNewRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(''),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          textTheme: Theme.of(context).textTheme,
          iconTheme: Theme.of(context).iconTheme,
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          elevation:
              appBarElevated && !ResponsiveContainer.isTablet(context) ? 4 : 0,
          actions: [],
          bottom: buildToolbarBottom()),
      // body is the majority of the screen.
      body: createRequestSend ? buildLoadingBody() : buildBody(),
      floatingActionButton:
          FloatingActionButton(onPressed: _save, child: Icon(Icons.save)),
    );
  }

  _scrollListener(
      double offset, double minScrollExtent, bool outOfRangePosition) {
    bool newElevationState;

    if (offset <= minScrollExtent && !outOfRangePosition) {
      newElevationState = false;
    } else {
      newElevationState = true;
    }

    if (newElevationState != appBarElevated) {
      setState(() {
        appBarElevated = newElevationState;
      });
    }
  }

  _onRoomCreated({Room result, String error}) {
    if (error != null) {
      setState(() {
        createRequestSend = false;
      });

      _showError(error, error: true);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WaitingRoomScreen()),
      );
    }
  }

  buildToolbarBottom() {
    return ResponsiveContainer.isTablet(context)
        ? null
        : NameInputContainer(
            alignment: Alignment(-1.0, 0.0),
            padding:
                const EdgeInsets.only(left: 56, right: PADDING_SIDE, bottom: 8),
            child: buildNameTf());
  }

  buildNameTf() {
    var titleController = new TextEditingController();
    titleController.text = createRoomBloc.getName();

    return TextField(
      autofocus: true,
      controller: titleController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      textCapitalization: TextCapitalization.sentences,
      maxLines: 1,
      decoration: InputDecoration(
          border: InputBorder.none, hintText: "Raumname eingeben"),
      onChanged: (text) {
        createRoomBloc.setRoomName(text);
      },
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
    );
  }

  buildBody() {
    return ResponsiveContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveContainer.isTablet(context)
                ? Container(
                    padding: const EdgeInsets.only(
                        left: PADDING_SIDE,
                        top: 8,
                        bottom: 8,
                        right: PADDING_SIDE),
                    child: buildNameTf(),
                  )
                : Container(),
            Divider(
              height: ResponsiveContainer.isTablet(context) || !appBarElevated
                  ? 2
                  : 0,
            ),
            EditRoomWidget()
          ], // Children
        ),
        scrollListener: _scrollListener);
  }

  buildLoadingBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: appBarElevated ? 0 : 2,
          ),
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ], // Children
      ),
    );
  }

  _save() {
    if (!createRequestSend) {
      if (!checkInput()) return;
      createRoomBloc.postNewRoom(_onRoomCreated);
      setState(() {
        createRequestSend = true;
      });
    }
  }

  bool checkInput() {
    if (createRoomBloc.getName() == "")
      return _showError("Raumname fehlt.");

    if (createRoomBloc.getAttributeCount() < 2)
      return _showError("Kein Attribut vorhanden.");

    for (Attribute attribute in createRoomBloc.getAttributes()) {
      if (attribute.name == "" &&
          attribute.values.length > 0 &&
          attribute.values[0].value != "") {
        return _showError("Ein Attribut hat keinen Namen.");
      }

      if (attribute.name == "") continue;

      if (attribute.values.length < 3) {
        return _showError(
            "Ein Attribut muss mindestens zwei Ausprägungen haben.");
      }

      int totalWeights = 0;

      for (var value in attribute.values) {
        totalWeights += value.weight;

        for (var checkValue in attribute.values) {
          if (checkValue == value) continue;
          if (checkValue.value == value.value) {
            return _showError(
                "Attribut ${attribute.name} enthält zwei gleiche Ausprägungen.");
          }
        }
      }

      if (totalWeights != 0 && totalWeights != 100) {
        return _showError(
            "Gewichte der Attributausprägungen müssen zusammen 100 ergeben.");
      }

      //check for duplicates
      for (Attribute checkAttribute in createRoomBloc.getAttributes()) {
        if (checkAttribute == attribute) continue;

        if (checkAttribute.name == attribute.name) {
          return _showError("Es existieren zwei Attribute mit gleichem Namen.");
        }
      }
    }

    return true;
  }

  bool _showError(String text, {bool error = false}) {
    var actions = <Widget>[];

    actions.add(FlatButton(
      child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));

    if (error) {
      actions.add(FlatButton(
        child: Text('ERNEUT VERSUCHEN', style: TextStyle(color: Theme.of(context).accentColor)),
        onPressed: () {
          _save();
          Navigator.of(context).pop();
        },
      ));
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error ? 'Fehler' : 'Falsche Eingabe'),
          content: Text(text),
          actions: actions,
        );
      },
    );

    return false;
  }
}

class NameInputContainer extends Container implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56);

  NameInputContainer({alignment, padding, child})
      : super(child: child, alignment: alignment, padding: padding);
}
