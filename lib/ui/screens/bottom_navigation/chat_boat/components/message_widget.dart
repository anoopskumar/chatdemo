import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {super.key, this.text, this.image, required this.isFromUser});
  final Image? image;
  final String? text;
  final bool isFromUser;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          constraints: BoxConstraints(maxWidth: 520),
          decoration: BoxDecoration(
            color: isFromUser ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              if (text case final text?)
                MarkdownBody(
                  data: text,
                ),

              if(image case final image?)image
            ],
          ),
        ))
      ],
    );
  }
}
