import 'package:chat_app/ui/screens/bottom_navigation/chat_boat/components/chat_widget.dart';
import 'package:flutter/material.dart';

class ChatBoatScreen extends StatefulWidget {
  const ChatBoatScreen({super.key});

  @override
  State<ChatBoatScreen> createState() => _ChatBoatScreenState();
}

class _ChatBoatScreenState extends State<ChatBoatScreen> {

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gemini Ai'),),
      body: ChatWidget(),
    );
  }
}