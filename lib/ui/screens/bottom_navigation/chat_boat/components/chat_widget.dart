import 'dart:convert';

import 'package:chat_app/ui/screens/bottom_navigation/chat_boat/components/gemini_service.dart';
import 'package:chat_app/ui/screens/bottom_navigation/chat_boat/components/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();

  bool _loading = false;

  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      [];

  late final String _apiKey;

  late final GeminiService _gemini;
final List<Map<String, dynamic>> _history = [];


  @override
  void initState() {
    super.initState();

    _apiKey = dotenv.env['API_KEY'] ?? '';

    if (_apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
      );
      _chat = _model.startChat();
    }

     _gemini = GeminiService(_apiKey);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_apiKey.isEmpty) {
      return const Center(child: Text('No API key found'));
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _generatedContent.length,
              itemBuilder: (context, index) {
                final content = _generatedContent[index];
                return MessageWidget(
                  isFromUser: content.fromUser,
                  text: content.text,
                  image: content.image,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _textFieldFocus,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Enter something...',
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_loading)
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () =>
                        _sendMessage(_textController.text.trim()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
  if (message.isEmpty || _loading) return;

  setState(() {
    _loading = true;
    _generatedContent.add(
      (image: null, text: message, fromUser: true),
    );
  });

  _scrollDown();
  _textController.clear();

  try {
    final reply = await _gemini.sendMessage(
      message: message,
      history: _history,
    );

    _history.add({
      "role": "user",
      "parts": [
        {"text": message}
      ]
    });

    _history.add({
      "role": "model",
      "parts": [
        {"text": reply}
      ]
    });

    setState(() {
      _generatedContent.add(
        (image: null, text: reply, fromUser: false),
      );
    });

    _scrollDown();
  } catch (e) {
    _showError(e.toString());
  } finally {
    setState(() => _loading = false);
    _textFieldFocus.requestFocus();
  }
}


  Future<void> sendMessage(String message) async {
    if (message.isEmpty || _loading) return;

    setState(() {
      _loading = true;
      _generatedContent.add(
        (image: null, text: message, fromUser: true),
      );
    });

    _scrollDown();
    _textController.clear();

    try {

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/{model=gemini-2.0-flash/*}:generateContent',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          "candidates": [
            {
              "content": {
                "parts": [
                  {"text": "Hello! How can I help you today?"}
                ]
              }
            }
          ]
        }),
      );



     // final response = await _chat.sendMessage(Content.text(message));
      final reply = response.body;

      if (reply == null) {
        _showError('No response from Gemini');
      } else {
        setState(() {
          _generatedContent.add(
            (image: null, text: reply, fromUser: false),
          );
        });
        _scrollDown();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Something went wrong'),
        content: SelectableText(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
