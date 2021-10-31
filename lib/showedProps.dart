import 'package:flutter/material.dart';
import 'colorFromHex.dart';
import 'appColors.dart';
import "toggleProp.dart";
import "package:provider/provider.dart";
import "stateModel.dart";

class ShowedProps extends StatefulWidget {
  const ShowedProps({Key key}) : super(key: key);

  @override
  _ShowedPropsState createState() => _ShowedPropsState();
}

class _ShowedPropsState extends State<ShowedProps> {

  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, providedClubs, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              child: ToggleButtons(
                direction: Axis.vertical,
                fillColor: colorFromHex(detectPropsBgColor),
                children: providedClubs.propInfoMap.keys.toList().asMap().entries.map((entry) =>
                    ToggleProp(macAddress: entry.value, propIndex: entry.key + 1)).toList(),
                isSelected: providedClubs.currentPropSelections,
                onPressed: (int index) {
                  setState(() {
                    providedClubs.updateCurrentPropSelections(index);
                  });
                },
              ),
            ),
          ),
        );
      });
  }
}
