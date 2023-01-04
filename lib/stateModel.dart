import 'OSCHandler.dart';
import 'package:flutter/cupertino.dart';
import "musicPlayerGlobal.dart";
import "propList.dart";
import 'dart:async';

final playerKey = GlobalKey<MusicPlayerGlobalState>();

class StateModel extends ChangeNotifier {

 Map<String, String> propInfoMap = Map(); //Map key = Mac Address, value = IP Address
 Map<String, double> pongTimes = Map(); // Pong responding times with Mac Addresses
 Map<String, bool> connectedProps = Map(); // keeps track of whether or not a prop is connected

 List<bool> currentPropSelections = [];
 List<OSCHandler> oscHandlerProps = [];
 List<bool> currentTabSelection = [true, false, false, false];
 String myIpAddress = "";
 Map<String, double> propBatteryLevelsMap = Map();
 Map<String, double> propBrightnessValuesMap = Map();
 List<String> sequenceNames = [];
 List<String> scriptNames = [];
 String dropdownValueSequence = "";
 String dropdownValueScript = "";
 MusicPlayerGlobal musicPlayerGlobal = MusicPlayerGlobal(key: playerKey);
 bool syncToMusic = true;
 int startMinute = 0;
 int startSecond = 0;
 final propListKey = GlobalKey<PropListState>();
 Timer startingTimer;
 Timer infoTimer;
 String sequenceInfo = "";
 String scriptInfo = "";
 double brightnessValue = 1;
 double irBrightnessValue = 0;
 bool pingPongStarted = false;

 void changeColorOfSelected(red, green, blue) {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
        oscHandlerProps[i].sendOscMessage("/rgb/fill", [red, green, blue]);
       }
     }
   }
 }

 void addBrightnessToMap(macAddress, receivedBrightness) {
   propBrightnessValuesMap[macAddress] = receivedBrightness;
 }

 void changeBrightnessOfSelected(brightnessValue) {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         String macAddress = propInfoMap.keys.toList()[i];
         propBrightnessValuesMap[macAddress] = brightnessValue;
         oscHandlerProps[i].sendOscMessage("/rgb/brightness", [brightnessValue]);
       }
     }
   }
   notifyListeners();
 }

 void changeIrBrightnessOfSelected(brightnessValue) {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/ir/brightness", [brightnessValue]);
       }
     }
   }
   notifyListeners();
 }

 void  turnOnIdsOfSelected() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/player/id", [1.0]);
       }
     }
   }
 }

 void  turnOffIdsOfSelected() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/player/id", [0.0]);
       }
     }
   }
 }

 void loadSequenceOnSelectedClubs(sequenceName) {

   if (sequenceName == "") return;

   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/player/load", [sequenceName]);
       }
     }
   }
   print("Loaded Sequence '${sequenceName}' On Selected Clubs");
   notifyListeners();
 }

 void loadScriptOnSelectedClubs(scriptName) {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/scripts/load", [scriptName]);
       }
     }
   }

   print("Loaded Script '${scriptName}' On Selected Clubs");
   changeScriptInfo("Started");
   notifyListeners();
 }

 void changeSequenceInfo(info) {
   try {
     infoTimer.cancel();
   } catch (e) {}

   sequenceInfo = info;
   infoTimer = Timer(Duration(milliseconds: 3000), () {
     sequenceInfo = "";
     notifyListeners();
   });
 }

 void changeScriptInfo(info) {
   try {
     infoTimer.cancel();
   } catch (e) {}

   scriptInfo = info;
   infoTimer = Timer(Duration(milliseconds: 3000), () {
     scriptInfo = "";
     notifyListeners();
   });
 }

 int getMusicDelay() {
     return ((startMinute * 60) + startSecond) * 1000;
 }

 void startSequenceOnSelectedClubs(sequenceName, startTimeInSeconds) {

   if (sequenceName == "") return;

   //Start music at starting time
   if (syncToMusic) {
     try {
       if (getMusicDelay() < 0) {
          startingTimer = Timer(Duration(milliseconds: getMusicDelay().abs()), () {
           if (playerKey.currentState.maximumValue >= startTimeInSeconds * 1000.0) {
             if (!playerKey.currentState.isPlaying) {
               playerKey.currentState.changePlayStatus();
             }

             playerKey.currentState.currentValue = startTimeInSeconds * 1000.0; //milliseconds
             playerKey.currentState.currentTime =  playerKey.currentState.getDuration(playerKey.currentState.currentValue);
             playerKey.currentState.player.seek(Duration(milliseconds: 0));
           }
         });
       } else {
         if (playerKey.currentState.maximumValue >= startTimeInSeconds * 1000.0) {
           if (!playerKey.currentState.isPlaying) {
             playerKey.currentState.changePlayStatus();
           }

           playerKey.currentState.currentValue = startTimeInSeconds * 1000.0; //milliseconds
           playerKey.currentState.currentTime =  playerKey.currentState.getDuration(playerKey.currentState.currentValue);
           playerKey.currentState.player.seek(Duration(milliseconds: playerKey.currentState.currentValue.round()));
         }
       }
     } catch(e) {}
   }

   //Start sequences in props
   int numOfStartingSignals = 3;
   for (int i = 0; i < numOfStartingSignals; i++) {
     Timer(Duration(milliseconds: i * 10), () {
       for (int j = 0; j < oscHandlerProps.length; j++) {
         if (currentPropSelections.length > 0) {
           if (currentPropSelections[j] == true) {
             oscHandlerProps[j].sendOscMessage("/player/load", [sequenceName]);
             double newStartTimeInSeconds = startTimeInSeconds + (i / 100); //adds .1 seconds to the starting time in every cycle
             oscHandlerProps[j].sendOscMessage("/player/play", [newStartTimeInSeconds]);
           }
         }
       }
     });
   }

   print("Started Sequence ${sequenceName} On Selected Clubs");
   changeSequenceInfo("Started");
   notifyListeners();
 }

 void pauseSequenceOnSelectedClubs() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/player/pause", []);
       }
     }
   }

   //Pause music player
   if (syncToMusic) {
     if (playerKey.currentState.isPlaying) {
       playerKey.currentState.changePlayStatus();
     }
     try {
       startingTimer.cancel();
     } catch (e) {}
   }

   print("Paused Sequence On Selected Clubs");
   changeSequenceInfo("Paused");
   notifyListeners();
 }

 void resumeSequenceOnSelectedClubs() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/player/resume", []);
       }
     }
   }

   //Resume music player
   if (syncToMusic) {
     if (!playerKey.currentState.isPlaying) {
       playerKey.currentState.changePlayStatus();
     }
     try {
       startingTimer.cancel();
     } catch (e) {}
   }

   print("Resumed Sequence On Selected Clubs");
   changeSequenceInfo("Resumed");
   notifyListeners();
 }

 void sendPingToAllClubs() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     oscHandlerProps[i].sendOscMessage("/ping", []);
   }
 }

 void updatePongTimeAtMacAddress(macAddress) {
   double timeInSeconds = DateTime.now().microsecondsSinceEpoch.toDouble() / 1000000;
   pongTimes[macAddress] = timeInSeconds;
 }

 void updateConnectedProps(macAddress, isConnected) {
   connectedProps[macAddress] = isConnected;
   notifyListeners();
 }

 void stopSequenceOnSelectedClubs() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/player/stop", []);
       }
     }
  }
   //Stop music player
   if (syncToMusic) {
     try {
       playerKey.currentState.stopPlaying();
       startingTimer.cancel();
     } catch (e) {}
   }

   print("Stoped Sequence On Selected Clubs");
   changeSequenceInfo("Stoped");
   notifyListeners();
 }

 void stopScriptOnSelectedClubs() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/scripts/stop", []);
       }
     }
   }

   print("Stoped Script On Selected Clubs");
   changeScriptInfo("Stoped");
   notifyListeners();
 }

 void shutdownSelected() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/root/sleep", []);
       }
     }
   }

   notifyListeners();
 }

 void restartSelected() {
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/root/restart", []);
       }
     }
   }
   notifyListeners();
 }

 void updateCurrentPropSelections(index) {
  currentPropSelections[index] = !currentPropSelections[index];
  notifyListeners();
 }

 void createOscHandlersForProps() {
  List<String> currentOscIps = oscHandlerProps.map((oscHandler) => oscHandler.remoteHostIp).toList();

   propInfoMap.values.toList().forEach((ipAddress) {
     if (!currentOscIps.contains(ipAddress)) {
      oscHandlerProps.add(OSCHandler(remotePort: 9000, remoteHostIp: ipAddress));
     }
   });
 }

 void addPropInfosToList(macAddress, ipAddress) {
  propInfoMap[macAddress] = ipAddress;
  currentPropSelections = List.generate(propInfoMap.length, (index) => true);

  notifyListeners();
 }

 void addSequenceNamesToList(newSequenceNames) {
   try {
     sequenceNames = (sequenceNames + newSequenceNames).toSet().toList();
     dropdownValueSequence = sequenceNames[0];
     // loadSequenceOnSelectedClubs(dropdownValueSequence);
     notifyListeners();
   } catch (e) {}
 }

 void addScriptNamesToList(newScriptNames) {
   try {
     scriptNames = (scriptNames + newScriptNames).toSet().toList();
     dropdownValueScript = scriptNames[0];
     // loadScriptOnSelectedClubs(dropdownValueScript);
     notifyListeners();
   } catch (e) {}
 }

 void resetSequenceList() {
   sequenceNames = [];
   dropdownValueSequence = "";
   scriptNames = [];
   dropdownValueScript = "";
   notifyListeners();
 }

 void selectAllProps() {
   currentPropSelections = List.generate(propInfoMap.length, (index) => true);
   notifyListeners();
 }

 void unselectAllProps() {
   currentPropSelections = List.generate(propInfoMap.length, (index) => false);
   notifyListeners();
 }

 void resetPropList() {
   propInfoMap = Map(); //Map key = Mac Address, value = IP Address
   currentPropSelections = [];
   oscHandlerProps = [];
   propBrightnessValuesMap = Map();
   connectedProps.clear();
   pongTimes.clear();
   resetSequenceList();
   notifyListeners();
 }

 void changeCurrentTabSelection(i) {
   for (int j = 0; j < currentTabSelection.length; j++) {
     if (i == j) {
       currentTabSelection[j] = true;
     }
     else {
       currentTabSelection[j] = false;
     }
   }
   notifyListeners();
 }

 void setIpAddress(ipAddress) {
   myIpAddress = ipAddress;
   notifyListeners();
 }

 int getBatteryLevel(macAddress) {
   try {
     int batteryPercentage = (propBatteryLevelsMap[macAddress] * 100).toInt();

     if (batteryPercentage > 100) {
       batteryPercentage = 100;
     }

     if (batteryPercentage < 0) {
       batteryPercentage = 0;
     }

     return batteryPercentage;
   } catch (e) {
     return 0;
   }
 }

 int getBrightness(macAddress) {
   try {
     int batteryPercentage = (propBrightnessValuesMap[macAddress] * 100).toInt();

     if (batteryPercentage > 100) {
       batteryPercentage = 100;
     }

     if (batteryPercentage < 0) {
       batteryPercentage = 0;
     }

     return batteryPercentage;
   } catch (e) {
     return 100;
   }
 }

 void updateBatteryLevels(macAddress, batteryLevel) {
   propBatteryLevelsMap[macAddress] = batteryLevel;
 }

}