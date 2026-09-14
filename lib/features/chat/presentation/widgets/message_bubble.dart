import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.text,
    required this.isFromUser,
    required this.time,
    super.key,
  });

  final String text;
  final bool isFromUser;
  final String time;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isFromUser ? const Color(0xFF6750A4) : Colors.white;
    final textColor = isFromUser ? Colors.white : const Color(0xFF38333F);

    return Align(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: IntrinsicWidth(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isFromUser ? 18 : 4),
                bottomRight: Radius.circular(isFromUser ? 4 : 18),
              ),
              boxShadow: isFromUser
                  ? null
                  : const [
                      BoxShadow(
                        color: Color(0x0D282230),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 11),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    time,
                    style: TextStyle(
                      color: isFromUser
                          ? Colors.white.withValues(alpha: 0.72)
                          : const Color(0xFF9A949F),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


