// lib/screens/senior_messaging_screen.dart
import 'package:flutter/material.dart';
import '../models/messagee.dart';
import '../services/message_service.dart';
import '../utils/constants.dart';

class SeniorMessagingScreen extends StatefulWidget {
  final String seniorId;
  final String aidantId;

  SeniorMessagingScreen({required this.seniorId, required this.aidantId});

  @override
  _SeniorMessagingScreenState createState() => _SeniorMessagingScreenState();
}

class _SeniorMessagingScreenState extends State<SeniorMessagingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messages =
        MessageService.getMessagesBetween(widget.seniorId, widget.aidantId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat avec l'Aidant"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final isMe = message.senderId == widget.seniorId;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Écrire un message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primaryColor),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                final message = Message(
                  senderId: widget.seniorId,
                  receiverId: widget.aidantId,
                  text: _controller.text.trim(),
                  timestamp: DateTime.now(),
                );
                MessageService.sendMessage(message);
                _controller.clear();
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
