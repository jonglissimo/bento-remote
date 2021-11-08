import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "stateModel.dart";

class SettingsSection extends StatefulWidget {
  const SettingsSection({Key key}) : super(key: key);

  @override
  _SettingsSectionState createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {

  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, globalState, child) {

        double screenWidth = MediaQuery.of(context).size.width;
        double tabSectionWidth = screenWidth * 0.7;
        double settingsSliderHeight = 40;

        return Container(
          width: tabSectionWidth,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: tabSectionWidth * 0.4,
                    transform: Matrix4.translationValues(0, 6, 0),
                    child: Text(
                      "LED Brightness",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: tabSectionWidth * 0.85,
                        transform: Matrix4.translationValues(0, 2, 0),
                        height: settingsSliderHeight,
                        child: Slider(
                          value: globalState.brightnessValue,
                          min: 0,
                          max: 1,
                          activeColor: Colors.amber,
                          onChanged: (newBrightnessValue) {
                            globalState.brightnessValue = newBrightnessValue;
                            globalState.changeBrightnessOfSelected(globalState.brightnessValue);
                          },
                        ),
                      ),
                      Container(
                        width: tabSectionWidth * 0.1,
                        child: Text(
                          (globalState.brightnessValue * 100).toInt().toString(),
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: tabSectionWidth * 0.4,
                    transform: Matrix4.translationValues(0, 6, 0),
                    child: Text(
                      "IR Brightness",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: tabSectionWidth * 0.85,
                        transform: Matrix4.translationValues(0, 2, 0),
                        height: settingsSliderHeight,
                        child: Slider(
                          value: globalState.irBrightnessValue,
                          min: 0,
                          max: 1,
                          activeColor: Colors.amber,
                          onChanged: (newBrightnessValue) {
                            globalState.irBrightnessValue = newBrightnessValue;
                            globalState.changeIrBrightnessOfSelected(globalState.irBrightnessValue);
                          },
                        ),
                      ),
                      Container(
                        width: tabSectionWidth * 0.1,
                        child: Text(
                          (globalState.irBrightnessValue * 100).toInt().toString(),
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
