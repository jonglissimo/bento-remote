import 'getColorFromHex.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import "appColors.dart";

class MusicPlayerGlobal extends StatefulWidget {
  MusicPlayerGlobal({Key key}) : super(key: key);

  @override
  MusicPlayerGlobalState createState() => MusicPlayerGlobalState();
}

class MusicPlayerGlobalState extends State<MusicPlayerGlobal> {

  double minimumValue = 0.0;
  double maximumValue = 0.0;
  double currentValue = 0.0;
  String currentTime = "0:00";
  String endTime = "0:00";
  bool isPlaying = false;
  String filePath = "";
  String fileName = "";
  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    player?.dispose();
  }

  void setFileNameFromPath(String path) {
    this.fileName = path.split("/").last;
  }

  String getCroppedFileName(filename) {
    int cutoff = 20;
    return (filename.length <= cutoff)
        ? filename
        : '${filename.substring(0, cutoff)}...';
  }

  void chooseFile() async {
    // stopPlaying();
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["mp3", "wav"],
    );

    if(result != null) {
      this.filePath = result.files.single.path;
    }

    setState(() {
      this.setFileNameFromPath(this.filePath);
      setSong(this.filePath);
    });
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds].map((element) {
      return element.remainder(60).toString().padLeft(2, "0");
    }).join(":");
  }

  void changePlayStatus() {
    setState(() {
      isPlaying = !isPlaying;

      if (isPlaying) {
        player.play();
      } else {
        player.pause();
      }

    });
  }

  void stopPlaying() {
    player.stop();
    setState(() {
      this.setFileNameFromPath(this.filePath);
      setSong(this.filePath);
    });
  }

  void setSong(String path) async {
    await player.setUrl(path);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomAreaHeight= screenHeight * 0.20;

    return Container(
      color: getColorFromHex(musicPlayerBgColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: bottomAreaHeight * 0.3,
            child: Slider(
              inactiveColor: Colors.grey,
              activeColor: Colors.white,
              min: minimumValue,
              max: maximumValue + 1001,
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
                player.seek(Duration(milliseconds: currentValue.round()));
              },
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -10, 0),
            width: screenWidth,
            height: bottomAreaHeight * 0.57,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenWidth * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        currentTime,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      GestureDetector(
                        child: Icon(
                          isPlaying?Icons.pause_circle_filled_rounded:Icons.play_circle_fill_rounded,
                          color: getColorFromHex(playPauseButtonColor),
                          size: screenWidth * 0.5 * 0.3,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          changePlayStatus();
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.stop_circle_outlined,
                          color: getColorFromHex(playPauseButtonColor),
                          size: screenWidth * 0.4 * 0.25,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          stopPlaying();
                        },
                      ),
                      Text(
                        endTime,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,5,0,0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: RadialGradient(
                              radius: 1.5,
                              colors: [
                                getColorFromHex(btnGradient1),
                                getColorFromHex(btnGradient2),
                              ],)
                        ),
                        width: screenWidth * 0.4,
                        height: bottomAreaHeight * 0.3,
                        child: TextButton(
                          child: Text(
                            "Choose Music File",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          onPressed: () {
                            this.chooseFile();
                          }
                        ),
                      ),
                      Container(
                        height: bottomAreaHeight * 0.2,
                        width: screenWidth * 0.40,
                        child: Center(
                          child: Text(
                            this.getCroppedFileName(this.fileName),
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}