
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotierte_redeliste/models/Room.dart';
import 'package:quotierte_redeliste/ui/create_room/CreateRoomBloc.dart';
import 'package:quotierte_redeliste/ui/create_room/EditRoomWidget.dart';
import 'package:quotierte_redeliste/ui/display_room/DisplayRoomScreen.dart';

class CreateRoomScreen extends StatefulWidget {
  CreateRoomScreen({Key key}) : super(key: key);

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();

}

class _CreateRoomScreenState extends State<CreateRoomScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const double PADDING_SIDE = 16;

  static const SAVE_BTN_ACT_COLOR = Colors.blueAccent;
  static const SAVE_BTN_DISABLED_COLOR = Colors.black12;

  var save_btn_color = SAVE_BTN_DISABLED_COLOR;

  bool appBarElevated = false;

  bool createRequestSend = false;

  @override
  void initState() {
    createRoomBloc.createNewRoom();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white
    ));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.black,
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: appBarElevated ? 4 : 0,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: PADDING_SIDE, left: PADDING_SIDE, top: 12, bottom: 12),
            child: FlatButton(
              color: save_btn_color,
              textColor: Colors.white,
              child: Text("Erstellen"),
              onPressed: (){
                if (!createRequestSend) {
                  createRoomBloc.postNewRoom(_onRoomCreated);
                  setState(() {
                    createRequestSend = true;
                  });
                }
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
            ),
          ),
        ],
        bottom: NameInputContainer(
            alignment: Alignment(-1.0, 0.0),
            padding: const EdgeInsets.only(left: 56 ,right: PADDING_SIDE),
            child: TextField(
              autofocus: true,
              cursorColor: Colors.black54,
              inputFormatters: [LengthLimitingTextInputFormatter(50),],
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name eingeben",
                  hintStyle: TextStyle( color: Colors.black54 )) ,
              onChanged: (text) {
                createRoomBloc.setRoomName(text);
                setState(() {
                  if(text.length > 0){
                    save_btn_color = SAVE_BTN_ACT_COLOR;
                  }else{
                    save_btn_color = SAVE_BTN_DISABLED_COLOR;
                  }
                });
              },
              style: TextStyle( color: Colors.black, fontSize: 26, fontWeight: FontWeight.normal ),
            )
        ),
      ),
      // body is the majority of the screen.
      backgroundColor: Colors.white,
      body: createRequestSend ? buildLoadingBody() : buildBody(),
    );
  }


  _scrollListener(offset, minScrollExtent, outOfRangePosition){
    bool newElevationState;
    
    if (offset <= minScrollExtent && !outOfRangePosition) {
      newElevationState = false;
    }else{
      newElevationState = true;
    }

    if(newElevationState != appBarElevated){
      setState(() {
        appBarElevated = newElevationState;
      });
    }
  }

  _onRoomCreated({Room result, String error}){
    if (error != null){
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
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);

      setState(() {
        createRequestSend = false;
      });
    }else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayRoomScreen(roomId: result.id,)),
      );
    }
  }

  buildBody(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.black38, height: appBarElevated ? 0 : 2, ),
          EditRoomWidget(scrollListener: _scrollListener),
        ], // Children
      ),
    );
  }

  buildLoadingBody(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.black38, height: appBarElevated ? 0 : 2, ),
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ], // Children
      ),
    );
  }
  
}


class NameInputContainer extends Container implements PreferredSizeWidget{

  @override
  Size get preferredSize => Size.fromHeight(56);

  NameInputContainer({alignment, padding, child}) : super( child : child, alignment : alignment, padding : padding);

}
