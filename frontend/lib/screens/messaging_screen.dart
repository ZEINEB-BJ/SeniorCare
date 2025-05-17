import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/message.dart';
import '../services/gemini_service.dart';

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<Message> _messages = [];
  bool _isLoading = false;

  final List<String> _quickReplies = [
    "Quel est mon programme médical aujourd'hui ?",
    "Rappelle-moi de prendre mes médicaments.",
    "Je veux parler à un médecin.",
    "Quels exercices puis-je faire aujourd'hui ?",
    "Appelle mon aidant, s'il te plaît.",
    "Que puis-je manger pour rester en bonne santé ?",
    "J'ai besoin d'aide à domicile.",
    "Raconte-moi une petite histoire.",
  ];

  void _sendMessage({String? quickReply}) async {
    final userMessage = quickReply ?? _messageController.text.trim();

    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.insert(
          0,
          Message(
            text: userMessage,
            isSentByUser: true,
            timestamp: DateTime.now(),
          ),
        );
        _listKey.currentState?.insertItem(0);
        _isLoading = true;
      });

      _messageController.clear();

      final botReply = await GeminiService.sendMessage(userMessage);

      setState(() {
        _messages.insert(
          0,
          Message(
            text: botReply,
            isSentByUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _listKey.currentState?.insertItem(0);
        _isLoading = false;
      });
    }
  }

  Widget _buildMessageBubble(Message message, Animation<double> animation) {
    final bool isUser = message.isSentByUser;

    return SizeTransition(
      sizeFactor: animation,
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.smart_toy, color: Colors.white),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      "Bot",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.smart_toy, color: Colors.white),
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Le bot écrit...",
            style: TextStyle(
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickReplies() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _quickReplies.map((reply) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(reply),
              onPressed: () => _sendMessage(quickReply: reply),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Assistant SeniorCare'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              reverse: true,
              padding: EdgeInsets.all(10),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                if (_isLoading && index == 0) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index], animation);
              },
            ),
          ),
          if (!_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: _buildQuickReplies(),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: "Écrivez votre message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.primaryColor),
                  onPressed: _isLoading ? null : () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
