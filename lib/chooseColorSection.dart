import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import "getColorFromHex.dart";
import 'stateModel.dart';

class ChooseColorSection extends StatefulWidget {
  const ChooseColorSection({Key key}) : super(key: key);

  @override
  _ChooseColorState createState() => _ChooseColorState();
}

class _ChooseColorState extends State<ChooseColorSection> {

  Color pickerColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<StateModel>(
        builder: (context, globalState, child) {

          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          double tabSectionWidth = screenWidth * 0.7;
          double topAreaHeight = screenHeight * 0.80;
          double bottomAreaHeight= screenHeight * 0.20;

          double solidColorPickerPadding = tabSectionWidth * 0.02;

          double solidColorPickerHeight = topAreaHeight * 0.08;
          double solidColorPickerWidth = topAreaHeight * 0.08;

          void changeColor(Color color) {
            setState(() {
              pickerColor = color;
              double red = color.red / 255.0;
              double green = color.green / 255.0;
              double blue = color.blue / 255.0;
              globalState.changeColorOfSelected(red, green, blue);
            });
          }

          return Column(
            children: [
              ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  colorPickerWidth: tabSectionWidth,
                  pickerAreaHeightPercent: 0.75,
                  enableAlpha: false,
                  displayThumbColor: true,
                  showLabel: false,
                  labelTextStyle: TextStyle(
                      color: Colors.white
                  ),
                  paletteType: PaletteType.hsv,
                  pickerAreaBorderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(2.0),
                    topRight: const Radius.circular(2.0),
                  )
              ),
              Container( //Solid Color Pickers
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#ff0000"));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#ff0000"),
                                ),
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#00ff00"));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#00ff00"),
                                ),
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#0000ff"));
                              },
                              child: Container(
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#0000ff"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#ffff00"));
                              },
                              child: Container(
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#ffff00"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#00ffff"));
                              },
                              child: Container(
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#00ffff"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#ff00ff"));
                              },
                              child: Container(
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#ff00ff"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#ffffff"));
                              },
                              child: Container(
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#ffffff"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(solidColorPickerPadding),
                            child: GestureDetector(
                              onTap: () {
                                changeColor(colorFromHex("#000000"));
                              },
                              child: Container(
                                width: solidColorPickerWidth,
                                height: solidColorPickerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorFromHex("#000000"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}