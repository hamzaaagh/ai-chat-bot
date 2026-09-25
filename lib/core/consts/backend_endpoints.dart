class BackendEndpoints {
  static const String baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/$aiModel:generateContent";
  static const String messages = '$baseUrl/messages';
  static const String aiModel = 'gemini-3-flash-preview';
}
