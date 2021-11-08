import 'dart:io';
import 'package:osc/osc.dart';

class OSCHandler {

  RawDatagramSocket socket;
  InternetAddress remoteHost;
  Function onMsgReceived;

  String remoteHostIp;
  int remotePort;

  OSCHandler({  this.remoteHostIp, this.remotePort, this.onMsgReceived }) {
    //Create Socket
    setRawDataGramSocket();

    //Set Remote Host IP Address
    this.setRemoteHost();
  }

  Future<void> setRawDataGramSocket() async{
    int socketPort = 10000;
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, socketPort);
    socket.broadcastEnabled = true;
    this.listen(this.onMsgReceived);

  }

  Future<void> listen(void Function(OSCMessage msg) onData) async {
    try {
      this.socket.listen((e) {
        final datagram = this.socket.receive();
        if (datagram != null) {
          // print(datagram.address);
          // print(datagram.port);
          final msg = OSCMessage.fromBytes(datagram.data);
          onData(msg);
        }
      });
    } catch (e) {}
  }

  void setRemoteHost() {
    try {
      this.remoteHost = InternetAddress(this.remoteHostIp);
    } catch (error) {
      print("Error while setting remote host - $error");
    }
  }

  void sendOscMessage(String message, List<Object> args) {
    OSCMessage oscMessage = new OSCMessage(message, arguments: args);

    this.socket.send(oscMessage.toBytes(), this.remoteHost, this.remotePort);
    print("Sent OSC message ${oscMessage.address} to ${this.remoteHost.address}");
  }
}