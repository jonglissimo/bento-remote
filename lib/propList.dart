import 'stateModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "appColors.dart";
import "colorFromHex.dart";
import "OSCHandler.dart";
import "dart:io";
import 'dart:async';
import 'showedProps.dart';


class PropList extends StatefulWidget {
  const PropList({Key key}) : super(key: key);

  @override
  PropListState createState() => PropListState();
}

class PropListState extends State<PropList> {

  OSCHandler oscHandlerBroadcast;

  String toggleAllBtnText = "Select All";
  String broadCastIpAddress;
  double brightnessValue = 1;

  String getBroadcastIp(String ipAddress) {
    List<String> broadCastIpList = ipAddress.split(".");
    broadCastIpList[broadCastIpList.length - 1] = "255";
    return broadCastIpList.join(".");
  }

  Future setIpAddress(providedClubs) async {
    List<dynamic> networkInterfaces = await NetworkInterface.list();
    List<String> possibleNetworkInterfaces = ["swlan0", "wlan0"];

    for (var interface in networkInterfaces) {
      if (possibleNetworkInterfaces.contains(interface.name)) {
        for (var addr in interface.addresses) {
          providedClubs.setIpAddress(addr.address);
          return;
        }
      }
    }

    if (providedClubs.myIpAddress == "" || providedClubs.myIpAddress== null) { // set ip of first interface, as default
      providedClubs.setIpAddress(networkInterfaces[0][0].address);
    }

  }

  Future refreshBroadcastSocket(providedClubs) async {
    await this.setIpAddress(providedClubs);
    this.broadCastIpAddress = getBroadcastIp(providedClubs.myIpAddress);
    oscHandlerBroadcast.remoteHostIp = this.broadCastIpAddress;
  }

  Future setBroadcastSocket(onOscReceived, providedClubs) async {
    await this.setIpAddress(providedClubs);
    this.broadCastIpAddress = getBroadcastIp(providedClubs.myIpAddress);
    oscHandlerBroadcast = OSCHandler(remotePort: 9000, remoteHostIp: this.broadCastIpAddress, onMsgReceived: onOscReceived);
  }

  void BroadcastToProps(onOscReceived, providedClubs) async {
    try {
      if (providedClubs.myIpAddress == "" || providedClubs.myIpAddress == null) {
        await setBroadcastSocket(onOscReceived, providedClubs);
        Timer(Duration(milliseconds: 500), () {
          oscHandlerBroadcast.sendOscMessage("/yo", [providedClubs.myIpAddress]);
          oscHandlerBroadcast.sendOscMessage("/files/list", []);
          oscHandlerBroadcast.sendOscMessage("/rgb/brightnessStatus", []);
        });
      } else {
        for (int i = 1; i < 10; i++) {
          Timer(Duration(milliseconds: i * 100), () {
            oscHandlerBroadcast.sendOscMessage("/yo", [providedClubs.myIpAddress]);
            oscHandlerBroadcast.sendOscMessage("/files/list", []);
            oscHandlerBroadcast.sendOscMessage("/rgb/brightnessStatus", []);
          });
        }
      }
    } catch (e) {}
  }

  List <String> filterSequenceNamesFromOscArguments(oscArguments) {
    String sequencesOneString = oscArguments[1];
    List sequencesList = sequencesOneString.split(",");
    List <String> sequences = [];
    for (String arg in sequencesList) {
      if (arg.contains(".meta")) {
        String sequenceName = arg.split(".meta")[0];
        sequences.add(sequenceName.replaceAll(' ', ''));
      }
    }
    return sequences;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<StateModel>(
      builder: (context, providedClubs, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        double topAreaHeight = screenHeight * 0.80;
        double propListWidth = screenWidth * 0.3;
        double detectPropsBtnHeight = 45;
        double selectBtnsHeight = 40;
        double clearPropsBtnHeight = 40;
        double spacerHeight = 2;

        void onOscReceived(msg) {

          if (msg.address == "/wassup") {
            String propIpAddress = msg.arguments[0];
            String propMacAddress = msg.arguments[1];
            Provider.of<StateModel>(context, listen: false).addPropInfosToList(propMacAddress, propIpAddress);
            providedClubs.createOscHandlersForProps();
          }

          if (msg.address == "/battery/level") {
            String propMacAddress = msg.arguments[0];
            double propBatteryLevel = msg.arguments[1];
            Provider.of<StateModel>(context, listen: false).updateBatteryLevels(propMacAddress, propBatteryLevel);
          }

          if (msg.address == "/files/list") {
            List sequenceNames = filterSequenceNamesFromOscArguments(msg.arguments);
            providedClubs.addSequenceNamesToList(sequenceNames);
          }

          if(msg.address == "/rgb/brightnessStatus") {
            String propMacAddress = msg.arguments[0];
            double propBrightnessLevel = msg.arguments[1];
            providedClubs.addBrightnessToMap(propMacAddress, propBrightnessLevel);
          }

          print("Received OSC Message - ${msg.address} ${msg.arguments}");
        }

        setBroadcastSocket(onOscReceived, providedClubs); //Init IP Address and set Broadcast Socket

        return Container(
          height: topAreaHeight,
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
             Container(
               width: propListWidth,
               height: detectPropsBtnHeight,
               color: colorFromHex(detectPropsBtnColor),
               child: TextButton(
                   onPressed: () {
                     BroadcastToProps(onOscReceived, providedClubs);
                   },
                   child: Text(
                     "Detect Props",
                     style: TextStyle(
                         color: Colors.white
                     ),
                   )
               ),
             ),
             Container(
               height: spacerHeight,
               color: Colors.white,
             ),
             Expanded(
               child: Container(
                 child: ShowedProps()
               ),
             ),
             SizedBox(
               height: spacerHeight,
             ),
             Container(
               width: propListWidth,
               height: selectBtnsHeight,
               color: colorFromHex(detectPropsBtnColor),
               child: TextButton(
                   onPressed: () {
                     providedClubs.selectAllProps();
                   },
                   child: Text(
                     "Select All",
                     style: TextStyle(
                         color: Colors.white
                     ),
                   )
               ),
             ),
             SizedBox(
               height: spacerHeight,
             ),
             Container(
               width: propListWidth,
               height: selectBtnsHeight,
               color: colorFromHex(detectPropsBtnColor),
               child: TextButton(
                   onPressed: () {
                     providedClubs.unselectAllProps();
                   },
                   child: Text(
                     "Unselect All",
                     style: TextStyle(
                         color: Colors.white
                     ),
                   )
               ),
             ),
             SizedBox(
               height: spacerHeight,
             ),
             Container(
               width: propListWidth,
               height: clearPropsBtnHeight,
               color: colorFromHex(detectPropsBtnColor),
               child: TextButton(
                   onPressed: () {
                     providedClubs.resetPropList();
                   },
                   child: Text(
                     "Clear Props",
                     style: TextStyle(
                         color: Colors.white
                     ),
                   )
               ),
             )
           ],
       ),
        );
      }
    );
  }
}
