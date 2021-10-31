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
        builder: (context, providedClubs, child) {
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
                            "IP Address: ${providedClubs.myIpAddress}",
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  providedClubs.myIpAddress = "";
                                  providedClubs.propListKey.currentState.refreshBroadcastSocket(providedClubs);
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
                        providedClubs.restartSelected();
                      },
                      icon: Icon(Icons.restart_alt)
                  ),
                  IconButton(
                      onPressed: () {
                        providedClubs.shutdownSelected();
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
