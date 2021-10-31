import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'stateModel.dart';
import "appColors.dart";
import "colorFromHex.dart";
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
          builder: (context, providedClubs, child) {

            double screenWidth = MediaQuery.of(context).size.width;
            double tabSectionWidth = screenWidth * 0.7;
            double controlBtnsWidth = tabSectionWidth / 2.1;
            double controlBtnsHeight = 50;
            double spacerHeight = 2;

            double getSequenceStartTime() {
              return (providedClubs.startMinute.toDouble() * 60) + providedClubs.startSecond;
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
                                  value: providedClubs.syncToMusic,
                                  activeColor: Colors.grey,
                                  onChanged:(newValue){
                                    setState(() {
                                      providedClubs.syncToMusic = newValue;
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
                                    color: colorFromHex(detectPropsBtnColor),
                                    child: TextButton(
                                        onPressed: () {
                                          providedClubs.turnOnIdsOfSelected();
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
                                    color: colorFromHex(detectPropsBtnColor),
                                    child: TextButton(
                                        onPressed: () {
                                          providedClubs.turnOffIdsOfSelected();
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
                                value: providedClubs.dropdownValue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                hint: Text(
                                  "No Sequences",
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                                dropdownColor: colorFromHex(sequenceBtnsColor),
                                items: providedClubs.sequenceNames.map((item) {
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
                                    providedClubs.dropdownValue = newValue;
                                    providedClubs.loadSequenceOnSelectedClubs(newValue);
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
                                value: providedClubs.startMinute,
                                minValue: -59,
                                maxValue: 59,
                                onChanged: (value) => setState(() => providedClubs.startMinute = value),
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
                                value: providedClubs.startSecond,
                                minValue: -59,
                                maxValue: 59,
                                onChanged: (value) => setState(() => providedClubs.startSecond = value),
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
                                  color: colorFromHex(sequenceBtnsColor),
                                  child: TextButton(
                                      onPressed: () {
                                        providedClubs.startSequenceOnSelectedClubs(providedClubs.dropdownValue, getSequenceStartTime());
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
                                  color: colorFromHex(sequenceBtnsColor),
                                  child: TextButton(
                                      onPressed: () {
                                        providedClubs.stopSequenceOnSelectedClubs();
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
                            SizedBox(height: spacerHeight * 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: controlBtnsWidth,
                                  height: controlBtnsHeight,
                                  color: colorFromHex(sequenceBtnsColor),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          providedClubs.pauseSequenceOnSelectedClubs();
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
                                  color: colorFromHex(sequenceBtnsColor),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          providedClubs.resumeSequenceOnSelectedClubs();
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
                                providedClubs.sequenceInfo,
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
