import 'stateModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "colorFromHex.dart";

class ToggleProp extends StatefulWidget {

  String macAddress;
  int propIndex;

  ToggleProp({Key key, this.macAddress, this.propIndex}) : super(key: key);

  @override
  _TogglePropState createState() => _TogglePropState(macAddress: this.macAddress, propIndex: this.propIndex);
}

class _TogglePropState extends State<ToggleProp> {

  String macAddress;
  int propIndex;

  _TogglePropState({ this.macAddress, this.propIndex });

  IconData getBatteryStatusIcon(int batteryStatus) {
    if (batteryStatus > 20) {
      return Icons.battery_full;
    } else {
      return Icons.battery_alert;
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double propListWidth = screenWidth * 0.3;
    double propHeight = 55;

    return  Consumer<StateModel>(
      builder: (context, globalState, child) {

      Color getBatteryStatusColor(int batteryStatus) {

        if (globalState.connectedProps.containsKey(this.macAddress)) {
          if (globalState.connectedProps[this.macAddress] == false) {
            return Colors.grey;
          }
        }

        if (batteryStatus > 90) {
          return colorFromHex("#00ff00");
        } else if (batteryStatus > 80){
          return colorFromHex("#00ff00");
        } else if (batteryStatus > 70){
          return colorFromHex("#98db00");
        } else if (batteryStatus > 60){
          return colorFromHex("#b6c700");
        } else if (batteryStatus > 50){
          return colorFromHex("#cdb200");
        } else if (batteryStatus > 40){
          return colorFromHex("#df9b00");
        } else if (batteryStatus > 30){
          return colorFromHex("#ee8200");
        } else if (batteryStatus > 20){
          return colorFromHex("#f86600");
        } else if (batteryStatus > 10){
          return colorFromHex("#fe4400");
        } else {
          return colorFromHex("#ff0000");
        }

      }

      double getIndexFontSize() {
          try {
            double fontSize = globalState.currentPropSelections[this.propIndex - 1] == true ? 16.5 : 13;
            return fontSize;
          } catch(e) {
            return 13;
          }
      }

      Color getIndexColor() {
        if (globalState.connectedProps.containsKey(this.macAddress)) {
          if (globalState.connectedProps[this.macAddress]) {
            return Colors.white;
          } else {
            return Colors.red;
          }
        } else {
          return Colors.white;
        }
      }

      Color getInfoColor() {
        if (globalState.connectedProps.containsKey(this.macAddress)) {
          if (globalState.connectedProps[this.macAddress]) {
            return Colors.white;
          } else {
            return Colors.grey;
          }
        } else {
          return Colors.white;
        }
      }

      Color getLightbulbColor() {
        if (globalState.connectedProps.containsKey(this.macAddress)) {
          if (globalState.connectedProps[this.macAddress]) {
            return Colors.amber;
          } else {
            return Colors.grey;
          }
        } else {
          return Colors.amber;
        }
      }

      return Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.white
              )
          ),
        ),
        width: propListWidth,
        height: propHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(this.propIndex.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getIndexColor(),
                    fontSize: getIndexFontSize(),
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: getLightbulbColor(),
                          size: 14,
                        ),
                        Text(
                          globalState.getBrightness(this.macAddress).toString(),
                          style: TextStyle(
                              color: getInfoColor(),
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          getBatteryStatusIcon(globalState.getBatteryLevel(this.macAddress)),
                          color: getBatteryStatusColor(globalState.getBatteryLevel(this.macAddress)),
                          size: 14,
                        ),
                        Text(
                          globalState.getBatteryLevel(this.macAddress).toString() + "%",
                          style: TextStyle(
                            color: getInfoColor(),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ]
                )
                ],
              ),
          ],
        ),
        );
      });
  }
}