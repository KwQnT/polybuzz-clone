import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApi {
  static const String _apiKey = String.fromEnvironment('OPENROUTER_KEY', defaultValue: '');
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _model = 'sao10k/l3-lunaris-8b:free';

  static Future<String> sendMessage(List<Map<String, String>> messages) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://github.com/KwQnT/polybuzz-clone',
          'X-Title': 'PolyBuzz Clone',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.9,
          'max_tokens': 800,
        }),
      );

      if (response.statusCode != 200) {
        return 'Ошибка ${response.statusCode}: ${response.body}';
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final choices = data['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        return 'Пустой ответ от модели';
      }
      return choices[0]['message']['content']?.toString() ?? '';
    } catch (e) {
      return 'Ошибка: $e';
    }
  }
}
