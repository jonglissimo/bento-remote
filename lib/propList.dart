import 'stateModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "appColors.dart";
import "getColorFromHex.dart";
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

  Future setIpAddress(globalState) async {
    List<dynamic> networkInterfaces = await NetworkInterface.list();
    List<String> possibleNetworkInterfaces = ["swlan0", "wlan0"];

    for (var interface in networkInterfaces) {
      if (possibleNetworkInterfaces.contains(interface.name)) {
        for (var addr in interface.addresses) {
          globalState.setIpAddress(addr.address);
          return;
        }
      }
    }

    if (globalState.myIpAddress == "" || globalState.myIpAddress== null) { // set ip of first interface, as default
      globalState.setIpAddress(networkInterfaces[0][0].address);
    }

  }

  Future refreshBroadcastSocket(globalState) async {
    await this.setIpAddress(globalState);
    this.broadCastIpAddress = getBroadcastIp(globalState.myIpAddress);
    oscHandlerBroadcast.remoteHostIp = this.broadCastIpAddress;
  }

  Future setBroadcastSocket(onOscReceived, globalState) async {
    await this.setIpAddress(globalState);
    this.broadCastIpAddress = getBroadcastIp(globalState.myIpAddress);
    oscHandlerBroadcast = OSCHandler(remotePort: 9000, remoteHostIp: this.broadCastIpAddress, onMsgReceived: onOscReceived);
  }

  void BroadcastToProps(onOscReceived, globalState) async {
    try {
      if (globalState.myIpAddress == "" || globalState.myIpAddress == null) {
        await setBroadcastSocket(onOscReceived, globalState);
        Timer(Duration(milliseconds: 500), () {
          oscHandlerBroadcast.sendOscMessage("/yo", [globalState.myIpAddress]);
          oscHandlerBroadcast.sendOscMessage("/files/list", []);
          oscHandlerBroadcast.sendOscMessage("/rgb/brightnessStatus", []);
        });
      } else {
        for (int i = 1; i < 7; i++) {
          Timer(Duration(milliseconds: i * 100), () {
            oscHandlerBroadcast.sendOscMessage("/yo", [globalState.myIpAddress]);
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

    if (sequences.length > 0) {
      sequences.insert(0, "");
    }

    return sequences;
  }

  List <String> filterScriptNamesFromOscArguments(oscArguments) {
    String scriptsOneString = oscArguments[1];
    List sequencesList = scriptsOneString.split(",");
    List <String> scripts = [];
    for (String arg in sequencesList) {
      if (arg.contains(".wasm")) {
        String sequenceName = arg.split(".wasm")[0];
        scripts.add(sequenceName.replaceAll(' ', ''));
      }
    }

    return scripts;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<StateModel>(
      builder: (context, globalState, child) {
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
            globalState.createOscHandlersForProps();
          }

          if (msg.address == "/battery/level") {
            String propMacAddress = msg.arguments[0];
            double propBatteryLevel = msg.arguments[1];
            Provider.of<StateModel>(context, listen: false).updateBatteryLevels(propMacAddress, propBatteryLevel);
          }

          if (msg.address == "/files/list") {
            List sequenceNames = filterSequenceNamesFromOscArguments(msg.arguments);
            List scriptNames = filterScriptNamesFromOscArguments(msg.arguments);
            globalState.addSequenceNamesToList(sequenceNames);
            globalState.addScriptNamesToList(scriptNames);
          }

          if(msg.address == "/rgb/brightnessStatus") {
            String propMacAddress = msg.arguments[0];
            double propBrightnessLevel = msg.arguments[1];
            globalState.addBrightnessToMap(propMacAddress, propBrightnessLevel);
          }

          if(msg.address == "/pong") {
            String propMacAddress = msg.arguments[0];
            globalState.updatePongTimeAtMacAddress(propMacAddress);
          }

          print("Received OSC Message - ${msg.address} ${msg.arguments}");
        }

        setBroadcastSocket(onOscReceived, globalState); //Init IP Address and set Broadcast Socket

        return Container(
          height: topAreaHeight,
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
             Container(
               width: propListWidth,
               height: detectPropsBtnHeight,
               decoration: BoxDecoration(
                   gradient: RadialGradient(
                     radius: 1.5,
                     colors: [
                       getColorFromHex(btnGradient1),
                       getColorFromHex(btnGradient2),
                     ],)
               ),
               child: TextButton(
                   onPressed: () {
                     BroadcastToProps(onOscReceived, globalState);

                     //send ping every 1 seconds
                     if (!globalState.pingPongStarted) {

                       globalState.sendPingToAllClubs();
                       Timer.periodic(new Duration(seconds: 1), (timer) {
                         globalState.sendPingToAllClubs();

                         double currentTimeInSeconds = DateTime.now().microsecondsSinceEpoch.toDouble() / 1000000;
                         globalState.pongTimes.forEach((macAddress, time) {

                           double timeSinceLastPong = currentTimeInSeconds - globalState.pongTimes[macAddress];

                           if (timeSinceLastPong > 3) { //check if last pong was more than 3 seconds ago
                             globalState.updateConnectedProps(macAddress, false);
                           } else {
                             globalState.updateConnectedProps(macAddress, true);
                           }

                         });

                       });
                       globalState.pingPongStarted = true;
                     }
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
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 gradient: RadialGradient(
                   radius: 1,
                   colors: [
                     getColorFromHex(btnGradient1),
                     getColorFromHex(btnGradient2),
                   ],
                 ),
               ),
               child: TextButton(
                   onPressed: () {
                     globalState.selectAllProps();
                   },
                   child: Text(
                     "Select All",
                     style: TextStyle(
                         color: Colors.white,
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
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 gradient: RadialGradient(
                   radius: 1,
                   colors: [
                     getColorFromHex(btnGradient1),
                     getColorFromHex(btnGradient2),
                   ],
                 ),
               ),
               child: TextButton(
                   onPressed: () {
                     globalState.unselectAllProps();
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
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 gradient: RadialGradient(
                   radius: 1,
                   colors: [
                     getColorFromHex(btnGradient1),
                     getColorFromHex(btnGradient2),
                   ],
                 ),
               ),
               child: TextButton(
                   onPressed: () {
                     globalState.resetPropList();
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
