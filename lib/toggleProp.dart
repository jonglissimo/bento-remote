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

  Color getBatteryStatusColor(int batteryStatus) {
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
      builder: (context, providedClubs, child) {

      double getIndexFontSize() {
          try {
            double fontSize = providedClubs.currentPropSelections[this.propIndex - 1] == true ? 16.5 : 13;
            return fontSize;
          } catch(e) {
            return 13;
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
                    color: Colors.white,
                    fontSize: getIndexFontSize(),
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Colors.amber,
                          size: 14,
                        ),
                        Text(
                          providedClubs.getBrightness(this.macAddress).toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          getBatteryStatusIcon(providedClubs.getBatteryLevel(this.macAddress)),
                          color: getBatteryStatusColor(providedClubs.getBatteryLevel(this.macAddress)),
                          size: 14,
                        ),
                        Text(
                          providedClubs.getBatteryLevel(this.macAddress).toString() + "%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
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
