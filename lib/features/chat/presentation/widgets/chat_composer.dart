import 'package:flutter/material.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({required this.onSend, this.isLoading = false, super.key});

  final ValueChanged<String> onSend;
  final bool isLoading;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isLoading) {
      return;
    }

    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              onSubmitted: (_) => _sendMessage(),
              decoration: const InputDecoration(
                hintText: 'Message Luma...',
                hintStyle: TextStyle(color: Color(0xFF9A949F)),
                prefixIcon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: Color(0xFF77727D),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            height: 50,
            child: IconButton.filled(
              onPressed: widget.isLoading ? null : _sendMessage,
              tooltip: 'Send message',
              icon: const Icon(Icons.arrow_upward_rounded),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF6750A4),
                disabledForegroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
