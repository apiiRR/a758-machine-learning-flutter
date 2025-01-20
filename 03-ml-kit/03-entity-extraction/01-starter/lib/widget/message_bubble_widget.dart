import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final String sender;
  final bool isMyChat;

  const MessageBubble({
    super.key,
    required this.content,
    required this.sender,
    this.isMyChat = false,
  });

  final textStyle = const TextStyle(
    color: Colors.black54,
    fontSize: 12.0,
  );

  final senderBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  final otherBorderRadius = const BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMyChat ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: textStyle,
          ),
          Card(
            color: isMyChat ? Colors.green.shade100 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: isMyChat ? senderBorderRadius : otherBorderRadius,
            ),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: MessageBubbleText(text: content),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubbleText extends StatelessWidget {
  final String text;

  const MessageBubbleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
