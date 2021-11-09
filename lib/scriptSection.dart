import "package:flutter/material.dart";
import 'stateModel.dart';
import "package:provider/provider.dart";
import 'colorFromHex.dart';
import 'appColors.dart';

class ScriptSection extends StatefulWidget {
  const ScriptSection({Key key}) : super(key: key);

  @override
  _ScriptSectionState createState() => _ScriptSectionState();
}

class _ScriptSectionState extends State<ScriptSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
        builder: (context, globalState, child) {

          double screenWidth = MediaQuery.of(context).size.width;
          double tabSectionWidth = screenWidth * 0.7;
          double controlBtnsWidth = tabSectionWidth / 2.1;
          double controlBtnsHeight = 50;

          return Container(
            width: tabSectionWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Text(
                        "Script",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    Container(
                      width: tabSectionWidth * 0.6,
                      child: DropdownButton(
                        value: globalState.dropdownValueScript,
                        icon: Icon(Icons.keyboard_arrow_down),
                        hint: Text(
                          "No Scripts",
                          style: TextStyle(
                              color: Colors.grey
                          ),
                        ),
                        dropdownColor: colorFromHex(sequenceBtnsColor),
                        items: globalState.scriptNames.map((item) {
                          return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          );
                        }
                        ).toList(),
                        onChanged: (newValue){
                          setState(() {
                            globalState.dropdownValueScript = newValue;
                            // globalState.loadSequenceOnSelectedClubs(newValue);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: controlBtnsWidth,
                      height: controlBtnsHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: RadialGradient(
                          radius: 1.2,
                          colors: [
                            colorFromHex(btnGradient1),
                            colorFromHex(btnGradient2),
                          ],
                        ),
                      ),
                      child: TextButton(
                          onPressed: () {
                            globalState.loadScriptOnSelectedClubs(globalState.dropdownValueScript);
                          },
                          child: Text(
                            "Start",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    Container(
                      width: controlBtnsWidth,
                      height: controlBtnsHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: RadialGradient(
                          radius: 1.2,
                          colors: [
                            colorFromHex(btnGradient1),
                            colorFromHex(btnGradient2),
                          ],
                        ),
                      ),
                      child: TextButton(
                          onPressed: () {
                            globalState.stopScriptOnSelectedClubs();
                          },
                          child: Text(
                            "Stop",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    globalState.scriptInfo,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}