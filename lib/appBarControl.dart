import "package:flutter/material.dart";
import "stateModel.dart";
import "package:provider/provider.dart";
import "propList.dart";

class AppBarControl extends StatefulWidget {
  const AppBarControl({Key key}) : super(key: key);

  @override
  _AppBarControlState createState() => _AppBarControlState();
}

class _AppBarControlState extends State<AppBarControl> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
        builder: (context, globalState, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                      child: Row(
                        children: [
                          Text(
                            "IP Address: ${globalState.myIpAddress}",
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  globalState.myIpAddress = "";
                                  globalState.propListKey.currentState.refreshBroadcastSocket(globalState);
                                });
                              },
                              icon: Icon(Icons.refresh)
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        globalState.restartSelected();
                      },
                      icon: Icon(Icons.restart_alt)
                  ),
                  IconButton(
                      onPressed: () {
                        globalState.shutdownSelected();
                      },
                      icon: Icon(Icons.power_settings_new)
                  )
                ],
              )
            ],
          );
        }
    );
  }
}
