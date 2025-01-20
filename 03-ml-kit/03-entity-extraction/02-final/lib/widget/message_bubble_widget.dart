import 'package:entity_extraction_app/controller/message_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
              // todo-02-controller-05: add controller before it calls
              child: ChangeNotifierProvider(
                create: (context) => MessageProvider(context.read()),
                child: MessageBubbleText(text: content),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// todo-03-run-01: change it into StatefulWidget
class MessageBubbleText extends StatefulWidget {
  final String text;
  const MessageBubbleText({
    super.key,
    required this.text,
  });

  @override
  State<MessageBubbleText> createState() => _MessageBubbleTextState();
}

class _MessageBubbleTextState extends State<MessageBubbleText> {
  // todo-03-run-02: setup initState and run the extracting text
  @override
  void initState() {
    super.initState();

    final provider = context.read<MessageProvider>();
    Future.microtask(() {
      provider.extractText(widget.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    // todo-03-run-03: consume the state via Consumer
    return Consumer<MessageProvider>(
      builder: (context, value, child) {
        // todo-03-run-04: set the loading widget based on the state
        final isExtracting = value.isExtracting;
        if (isExtracting) {
          return Center(child: LinearProgressIndicator());
        }

        // todo-03-run-05: change the Text widget into RichText
        final listOfEntityAnnotation = value.listOfEntityAnnotation;
        return RichText(
          text: TextSpan(
            children: _getTextSpans(listOfEntityAnnotation),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }

  List<TextSpan> _getTextSpans(List<EntityAnnotation> entities) {
    List<TextSpan> textSpans = <TextSpan>[];
    int i = 0;
    int pos = 0;

    while (i < widget.text.length) {
      textSpans.add(_text(widget.text.substring(
          i,
          pos < entities.length && i <= entities[pos].start
              ? entities[pos].start
              : widget.text.length)));
      if (pos < entities.length && i <= entities[pos].start) {
        textSpans.add(_link(
            widget.text.substring(entities[pos].start, entities[pos].end),
            entities[pos].entities.first.type.name));
        i = entities[pos].end;
        pos++;
      } else {
        i = widget.text.length;
      }
    }
    return textSpans;
  }

  TextSpan _text(String text) {
    return TextSpan(text: text, style: TextStyle(color: Colors.black));
  }

  TextSpan _link(String text, String type) {
    return TextSpan(
      text: text,
      style: TextStyle(color: Colors.blue),
      // todo-04-launcher-04: add a gesture action
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          _entityAction(text, type);
        },
    );
  }

  // todo-04-launcher-02: add a function to launch the url
  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  // todo-04-launcher-03: setup the entity action
  void _entityAction(String text, String type) async {
    switch (type) {
      case "url":
      case "email":
      case "phone":
        final uri = switch (type) {
          "url" => text.substring(0, 4) == 'http' ? text : 'https://$text',
          "email" => text.substring(0, 7) == 'mailto:' ? text : 'mailto:$text',
          "phone" => text.substring(0, 4) == 'tel:' ? text : 'tel:$text',
          _ => text,
        };
        await _launchUrl(Uri.parse(uri));
        break;

      default:
    }
  }
}
