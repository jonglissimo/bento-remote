import 'OSCHandler.dart';
import 'package:flutter/cupertino.dart';
import "musicPlayerGlobal.dart";
import "propList.dart";
import 'dart:async';

final playerKey = GlobalKey<MusicPlayerGlobalState>();

class StateModel extends ChangeNotifier {

 Map<String, String> propInfoMap = Map(); //Map key = Mac Address, value = IP Address
 List<bool> currentPropSelections = [];
 List<OSCHandler> oscHandlerProps = [];
 List<bool> currentTabSelection = [true, false, false];
 String myIpAddress = "";
 Map<String, double> propBatteryLevelsMap = Map();
 Map<String, double> propBrightnessValuesMap = Map();
 List<String> sequenceNames = [];
 String dropdownValue = "";
 MusicPlayerGlobal musicPlayerGlobal = MusicPlayerGlobal(key: playerKey);
 bool syncToMusic = true;
 int startMinute = 0;
 int startSecond = 0;
 final propListKey = GlobalKey<PropListState>();
 Timer startingTimer;
 Timer infoTimer;
 String sequenceInfo = "";
 double brightnessValue = 1;
 double irBrightnessValue = 0;

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

 int getMusicDelay() {
     return ((startMinute * 60) + startSecond) * 1000;
 }

 void startSequenceOnSelectedClubs(sequenceName, startTimeInSeconds) {

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
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/player/load", [sequenceName]);
         oscHandlerProps[i].sendOscMessage("/player/play", [startTimeInSeconds]);
       }
     }
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

 void shutdownSelected() {
   List<int> oscHandlerIndicesToDelete = [];
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/root/sleep", []);
         // oscHandlerIndicesToDelete.add(i);
       }
     }
   }

   //Re-Create prop list after shutting down selected props
   // for (int index in oscHandlerIndicesToDelete.reversed) {
   //   oscHandlerProps.removeAt(index);
   // }
   // propInfoMap = Map(); //Map key = Mac Address, value = IP Address
   // currentPropSelections = [];
   // for (int i = 0; i < oscHandlerProps.length; i++) {
   //   oscHandlerProps[i].sendOscMessage("/yo", [myIpAddress]);
   // }
   notifyListeners();
 }

 void restartSelected() {
   List<int> oscHandlerIndicesToDelete = [];
   for (int i = 0; i < oscHandlerProps.length; i++) {
     if (currentPropSelections.length > 0) {
       if (currentPropSelections[i] == true) {
         oscHandlerProps[i].sendOscMessage("/root/restart", []);
         // oscHandlerIndicesToDelete.add(i);
       }
     }
   }

   //Re-Create prop list after shutting down selected props
   // for (int index in oscHandlerIndicesToDelete.reversed) {
   //   oscHandlerProps.removeAt(index);
   // }
   // propInfoMap = Map(); //Map key = Mac Address, value = IP Address
   // propBrightnessValuesMap = Map();
   // currentPropSelections = [];
   // for (int i = 0; i < oscHandlerProps.length; i++) {
   //   oscHandlerProps[i].sendOscMessage("/yo", [myIpAddress]);
   // }
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
  // createOscHandlersForProps();

  // if (!propBatteryLevelsMap.containsKey(macAddress)) {
  //   propBrightnessValuesMap[macAddress] = 100;
  // }

  notifyListeners();
 }

 void addSequenceNamesToList(newSequenceNames) {
   try {
     sequenceNames = (sequenceNames + newSequenceNames).toSet().toList();
     dropdownValue = sequenceNames[0];
     loadSequenceOnSelectedClubs(dropdownValue);
     notifyListeners();
   } catch (e) {}
 }

 void resetSequenceList() {
   sequenceNames = [];
   dropdownValue = "";
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