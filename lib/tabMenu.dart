import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "colorFromHex.dart";
import 'appColors.dart';
import "stateModel.dart";
import "tabContent.dart";


class TabBarMenu extends StatefulWidget {
  const TabBarMenu({Key key}) : super(key: key);

  @override
  _TabBarMenuState createState() => _TabBarMenuState();
}

class _TabBarMenuState extends State<TabBarMenu> {

  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, providedClubs, child) {

      double screenWidth = MediaQuery.of(context).size.width;
      double tabSectionWidth = screenWidth * 0.7;

      return Column(
        children: [
          Container(
            width: tabSectionWidth,
            child: ToggleButtons(
              fillColor: colorFromHex(detectPropsBgColor),
              color: Colors.white,
              selectedColor: Colors.white,
              renderBorder: false,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: Colors.white
                        ),
                        right: BorderSide(
                            color: Colors.white
                        )
                    ),
                  ),
                  alignment: Alignment.center,
                  width: tabSectionWidth / providedClubs.currentTabSelection.length,
                  height: 45,
                  child: Text(
                    "Color",
                    style: TextStyle(
                      fontSize: 12
                    )
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: Colors.white
                        ),
                        right: BorderSide(
                            color: Colors.white
                        )
                    ),
                  ),
                  alignment: Alignment.center,
                  width: tabSectionWidth / providedClubs.currentTabSelection.length,
                  height: 45,
                  child: Text(
                      "Sequence",
                      style: TextStyle(
                          fontSize: 12
                      )
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: Colors.white
                        ),
                        right: BorderSide(
                            color: Colors.white
                        )
                    ),
                  ),
                  alignment: Alignment.center,
                  width: tabSectionWidth / providedClubs.currentTabSelection.length,
                  height: 45,
                  child: Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 12
                      )
                  ),
                ),
              ],
              isSelected: providedClubs.currentTabSelection,
              onPressed: (int index) {
                providedClubs.changeCurrentTabSelection(index);
              },
            ),
          ),
          TabContent(),
        ]
      );
    });
}}