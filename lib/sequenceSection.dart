import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'stateModel.dart';
import "appColors.dart";
import "getColorFromHex.dart";
import "package:numberpicker/numberpicker.dart";

class SequenceSection extends StatefulWidget {
  const SequenceSection({Key key}) : super(key: key);

  @override
  _SequenceSectionState createState() => _SequenceSectionState();
}

class _SequenceSectionState extends State<SequenceSection> {

  @override
  Widget build(BuildContext context) {

    return Consumer<StateModel>(
          builder: (context, globalState, child) {

            double screenWidth = MediaQuery.of(context).size.width;
            double tabSectionWidth = screenWidth * 0.7;
            double controlBtnsWidth = tabSectionWidth / 2.1;
            double controlBtnsHeight = 50;
            double spacerHeight = 2;

            double getSequenceStartTime() {
              return (globalState.startMinute.toDouble() * 60) + globalState.startSecond;
            }

            return Container(
              child: Column(
                children: [
                  Container(
                    width: tabSectionWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: Text(
                                "Sync To Music",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: Colors.white),
                              child: Checkbox(
                                  value: globalState.syncToMusic,
                                  activeColor: Colors.grey,
                                  onChanged:(newValue){
                                    setState(() {
                                      globalState.syncToMusic = newValue;
                                    });
                                  }
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: Text(
                                "ID Mode",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Row(
                                children: [
                                  Container(
                                    width: tabSectionWidth * 0.3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: RadialGradient(
                                        radius: 1.2,
                                        colors: [
                                          getColorFromHex(btnGradient1),
                                          getColorFromHex(btnGradient2),
                                        ],
                                      ),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          globalState.turnOnIdsOfSelected();
                                        },
                                        child: Text(
                                          "On",
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: tabSectionWidth * 0.3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: RadialGradient(
                                        radius: 1.2,
                                        colors: [
                                          getColorFromHex(btnGradient1),
                                          getColorFromHex(btnGradient2),
                                        ],
                                      ),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          globalState.turnOffIdsOfSelected();
                                        },
                                        child: Text(
                                          "Off",
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: Text(
                                "Sequence",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                              width: tabSectionWidth * 0.6,
                              child: DropdownButton(
                                value: globalState.dropdownValueSequence,
                                icon: Icon(Icons.keyboard_arrow_down),
                                hint: Text(
                                  "No Sequences",
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                                dropdownColor: getColorFromHex(sequenceBtnsColor),
                                items: globalState.sequenceNames.map((item) {
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
                                    globalState.dropdownValueSequence = newValue;
                                    globalState.loadSequenceOnSelectedClubs(newValue);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: tabSectionWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Starting Minute:",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              NumberPicker(
                                itemWidth: 50,
                                axis: Axis.horizontal,
                                textStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                selectedTextStyle: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white
                                ),
                                value: globalState.startMinute,
                                minValue: -59,
                                maxValue: 59,
                                onChanged: (value) => setState(() => globalState.startMinute = value),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: tabSectionWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Starting Second:",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              NumberPicker(
                                itemWidth: 50,
                                axis: Axis.horizontal,
                                textStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                selectedTextStyle: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white
                                ),
                                value: globalState.startSecond,
                                minValue: -59,
                                maxValue: 59,
                                onChanged: (value) => setState(() => globalState.startSecond = value),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: controlBtnsWidth,
                                  height: controlBtnsHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green
                                    // gradient: RadialGradient(
                                    //   radius: 1.2,
                                    //   colors: [
                                    //     getColorFromHex(btnGradient1),
                                    //     Colors.green
                                    //   ],
                                    // ),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        globalState.startSequenceOnSelectedClubs(globalState.dropdownValueSequence, getSequenceStartTime());
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
                                      color: Colors.red
                                    // gradient: RadialGradient(
                                    //   radius: 1.2,
                                    //   colors: [
                                    //     getColorFromHex(btnGradient1),
                                    //     Colors.red
                                    //   ],
                                    // ),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        globalState.stopSequenceOnSelectedClubs();
                                      },
                                      child: Text(
                                        "Stop",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacerHeight * 3),
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
                                        getColorFromHex(btnGradient1),
                                        getColorFromHex(btnGradient2),
                                      ],
                                    ),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          globalState.pauseSequenceOnSelectedClubs();
                                        });
                                      },
                                      child: Text(
                                        "Pause",
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
                                        getColorFromHex(btnGradient1),
                                        getColorFromHex(btnGradient2),
                                      ],
                                    ),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          globalState.resumeSequenceOnSelectedClubs();
                                        });
                                      },
                                      child: Text(
                                        "Resume",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                                globalState.sequenceInfo,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
    );
  }
}