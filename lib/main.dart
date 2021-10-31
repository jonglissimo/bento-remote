import 'propList.dart';
import 'package:flutter/material.dart';
import "tabMenu.dart";
import "appColors.dart";
import 'colorFromHex.dart';
import "package:provider/provider.dart";
import 'stateModel.dart';
import "appBarControl.dart";
import 'package:wakelock/wakelock.dart';

void main() {

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _HomeState() {
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {

    double appBarHeight = 50.0;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height - appBarHeight - statusBarHeight;

    double topAreaHeight = screenHeight * 0.80;
    double bottomAreaHeight= screenHeight * 0.20;
    double propListWidth = screenWidth * 0.3;
    double tabSectionWidth = screenWidth * 0.7;

    return ChangeNotifierProvider(
      create: (context) => StateModel(),
      child: Consumer<StateModel>(
        builder: (context, providedClubs, child) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: appBarHeight,
              title: AppBarControl(),
              backgroundColor: colorFromHex("#363636"),
            ),
            body: Container(
              height: screenHeight,
              child: Column( //Main Column
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container( //Top Area
                    height: topAreaHeight,
                    child: Row(
                      children: [
                        Container( //Prop List
                          color: colorFromHex(propListBgColor),
                          width: propListWidth,
                          child: PropList(key: providedClubs.propListKey),
                        ),
                        Container( // Tab Section
                          color: colorFromHex(mainBgColor),
                          height: screenHeight,
                          width: tabSectionWidth,
                          child: TabBarMenu(),
                        ),
                      ],
                    ),
                  ),
                  Container( //Bottom Area
                      height: bottomAreaHeight,
                      width: screenWidth,
                      child: providedClubs.musicPlayerGlobal
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}