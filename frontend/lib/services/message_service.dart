// lib/services/message_service.dart
import '../models/messagee.dart';

class MessageService {
  static final List<Message> _messages = [];

  static List<Message> getMessagesBetween(String userId1, String userId2) {
    return _messages
        .where((message) =>
            (message.senderId == userId1 && message.receiverId == userId2) ||
            (message.senderId == userId2 && message.receiverId == userId1))
        .toList();
  }

  static void sendMessage(Message message) {
    _messages.add(message);
  }
}
