class MessageModel {
  const MessageModel({required this.role, required this.text});

  factory MessageModel.user(String text) {
    return MessageModel(role: 'user', text: text);
  }

  factory MessageModel.model(String text) {
    return MessageModel(role: 'model', text: text);
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'];
    final parts = json['parts'];

    if (role is! String || parts is! List) {
      throw const FormatException('Invalid Gemini message format.');
    }

    final textParts = <String>[];
    for (final part in parts) {
      if (part is! Map) {
        continue;
      }

      final text = part['text'];
      if (text is String) {
        textParts.add(text);
      }
    }

    return MessageModel(role: role, text: textParts.join());
  }

  final String role;
  final String text;

  Map<String, dynamic> toJson() {
    final part = <String, dynamic>{'text': text};

    return {
      'role': role,
      'parts': [part],
    };
  }
}
