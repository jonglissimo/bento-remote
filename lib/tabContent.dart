import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "stateModel.dart";
import 'chooseColorSection.dart';
import "sequenceSection.dart";
import 'settingsSection.dart';
import 'scriptSection.dart';

class TabContent extends StatefulWidget {
  const TabContent({Key key}) : super(key: key);

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, globalState, child) {

        int currentTabContent;
        for (int i = 0; i < globalState.currentTabSelection.length; i++) {
          if (globalState.currentTabSelection[i] == true) {
            currentTabContent = i;
            break;
          }
        }

        switch (currentTabContent) {
          case 0:
            return ChooseColorSection();
          case 1:
            return SequenceSection();
          case 2:
            return ScriptSection();
          case 3:
            return SettingsSection();
        }

        return Text("");
      });
  }
}