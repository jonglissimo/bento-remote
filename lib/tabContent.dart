import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "stateModel.dart";
import 'colorPicker.dart';
import "sequenceSection.dart";
import 'settingsSection.dart';

class TabContent extends StatefulWidget {
  const TabContent({Key key}) : super(key: key);

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, providedClubs, child) {

        int currentTabContent;
        for (int i = 0; i < providedClubs.currentTabSelection.length; i++) {
          if (providedClubs.currentTabSelection[i] == true) {
            currentTabContent = i;
            break;
          }
        }

        switch (currentTabContent) {
          case 0:
            return ChooseColor();
          case 1:
            return SequenceSection();
          case 2:
            return SettingsSection();
        }

        return Text("");
      });
  }
}
