import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:checktrack/system/apiSystem.dart';
const String SERVER_URL = "http://172.10.5.144";
const int PORT_NO = 443;

class SocketSystem{
  static late IO.Socket socket;
  static void initSocket(){
    socket = IO.io("$SERVER_URL:$PORT_NO", <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.onConnect((_){
      print("CONNECTED");
      socket.emit('message', "FROM CLIENT");
      socket.on("message", (data){
        print("RECEIVED: $data");
      });
    });
  }

  static void startTimer(int bookNo){
    int userNo = APISystem.getUserEntity().userNo;

    Map messageMap = {
      'userNo': userNo,
      'startTime': DateTime.now().millisecondsSinceEpoch,
      'bookNo': bookNo,
    };
    socket.emit("timer-startTimer", messageMap);
  }

  static void disconnectSocket(){
    socket.disconnect();
  }
}