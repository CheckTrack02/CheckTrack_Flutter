import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/system/TimerSystem.dart';
const String SERVER_URL = "http://172.10.5.144";
const int PORT_NO = 443;


class SocketSystem{
  static late IO.Socket socket;
  static bool isInitSocket = false;
  static late TimerSystem timerSystem;
  static void initSocket(){
    if(!isInitSocket){
      isInitSocket = true;
      print("INIT SOCKET");
      socket = IO.io("$SERVER_URL:$PORT_NO", <String, dynamic>{
        'transports': ['websocket'],
      });
    }else{
      socket.connect();
    }
    socket.onConnect((_){
      print("CONNECTED");
      socket.emit('message', "FROM CLIENT");
      socket.on("message", (data){
        print("RECEIVED: $data");
      });
      socket.on('userList', (data){
        print("RECEIVED: $data");
        TimerSystem.initUserList(data);
      });

      socket.on('updateUser', (data){
        print("RECEIVED: $data");
        String userName = data['userName'];
        if(userName!=APISystem.getUserEntity().userName){
          int userTime = data['userTime'];
          int userPage = data['userPage'];
          int startTime = data['startTime'];
          print(userName + " " + userTime.toString() + " " + userPage.toString() + " " + startTime.toString());
          TimerSystem.updateUser(userName, userTime, userPage, startTime);
        }
      });

      socket.on('removeUser', (data){
        print("RECEIVED: $data");
        String userName = data['userName'];
        if(userName!=APISystem.getUserEntity().userName){
          int userTime = data['userTime'];
          int userPage = data['userPage'];
          int startTime = data['startTime'];
          print("REMOVE : " + userName + " " + userTime.toString() + " " + userPage.toString() + " " + startTime.toString());
          TimerSystem.removeUser(userName, userTime, userPage, startTime);
        }
      });
    });
  }

  static void startTimer(int bookNo){
    int userNo = APISystem.getUserEntity().userNo;
    String userName = APISystem.getUserEntity().userName;
    int startTime = DateTime.now().millisecondsSinceEpoch;
    TimerSystem.currentStartTime = startTime;
    Map messageMap = {
      'userNo': userNo,
      'userName': userName,
      'startTime': startTime,
      'bookNo': bookNo,
    };
    socket.emit("timer-startTimer", messageMap);
  }

  static void disconnectSocket(){
    socket.dispose();
  }

  static void updateBookPage(int userPage, int userTime){
    
    int startTime = DateTime.now().millisecondsSinceEpoch;
    print(userPage.toString() + " " + userTime.toString() + " " + startTime.toString());
    Map messageMap = {
      'startTime': startTime,
      'userPage': userPage,
      'userTime': userTime,
    };
    socket.emit("timer-updateBookPage", messageMap);
  }
}