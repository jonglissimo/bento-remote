import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "getColorFromHex.dart";
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
      builder: (context, globalState, child) {

      double screenWidth = MediaQuery.of(context).size.width;
      double tabSectionWidth = screenWidth * 0.7;

      List<double> getTabTextSizes() {
        List<double> tabTextSizes = [];
        globalState.currentTabSelection.forEach((selection) {
          if (selection == true) {
            tabTextSizes.add(13.0);
          } else {
            tabTextSizes.add(12.0);
          }
        });

        return tabTextSizes;
      }

      List<double> tabTextSizes = getTabTextSizes();

      return Column(
        children: [
          Container(
            width: tabSectionWidth,
            color: getColorFromHex(detectPropsBtnColor),
            child: ToggleButtons(
              fillColor: getColorFromHex(propListBgColor),
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
                  width: tabSectionWidth / globalState.currentTabSelection.length,
                  height: 45,
                  child: Text(
                    "Color",
                    style: TextStyle(
                      fontSize: tabTextSizes[0],
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
                  width: tabSectionWidth / globalState.currentTabSelection.length,
                  height: 45,
                  child: Text(
                      "Sequence",
                      style: TextStyle(
                          fontSize: tabTextSizes[1]
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
                  width: tabSectionWidth / globalState.currentTabSelection.length,
                  height: 45,
                  child: Text(
                      "Script",
                      style: TextStyle(
                          fontSize: tabTextSizes[2]
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
                  width: tabSectionWidth / globalState.currentTabSelection.length,
                  height: 45,
                  child: Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: tabTextSizes[3]
                      )
                  ),
                )
              ],
              isSelected: globalState.currentTabSelection,
              onPressed: (int index) {
                globalState.changeCurrentTabSelection(index);
              },
            ),
          ),
          TabContent(),
        ]
      );
    });
}}