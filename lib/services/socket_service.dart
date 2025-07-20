import 'manage_http_response.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketService {
  static final SocketService _instance = SocketService._internal();
  static IO.Socket? _socket;

  SocketService._internal();

  // Function(dynamic data)? onLoginEvent;
  // Function(dynamic data)? onLogoutEvent;
  factory SocketService(){
    return _instance;
  }
  static void initSocketConnection(){
    _socket = IO.io(
        'http://192.168.1.3:3000',
        IO.OptionBuilder().setTransports(['websocket']).build()
      );
    _socket!
      ..onConnect((_) => print('✅ Socket connected'))
      ..onDisconnect((_) => print('🔌 Socket disconnected'))
      ..onConnectError((e) => print('❌ Socket connect error: $e'))
      ..onError((e) => print('❌ General socket error: $e'));
  }
  // void joinSession(String userId){
  //   _socket.emit('user-join', userId);
  // }
  static void listenUserUpdates(Function onUserUpdated) {
    _socket?.on('user_updated', (data) {
      print('👂 User updated event received');
      onUserUpdated();
    });
  }
  static void dispose() {
    _socket?.dispose();
  }

}