/// 长记忆生成相关的小工具：构造"提炼记忆"的请求，并清理模型输出。
class MemoryHelper {
  /// 提炼记忆的系统提示（要求输出记忆条目，而不是续写对话）
  static const String systemPrompt =
      '你是记忆整理助手。请阅读对话记录，提炼值得长期记住的关键信息'
      '（人物关系、偏好、约定、重要事件等），输出 1~3 条简短陈述，每行一条，'
      '以"- "开头。只输出记忆条目本身，不要复述对话、不要续写、不要解释。';

  /// 把历史消息拼成一段"对话记录"文本（不作为对话轮次，避免模型续写）。
  static String buildTranscript(List<(String who, String content)> turns) {
    final sb = StringBuffer();
    for (final t in turns) {
      if (t.$2.trim().isEmpty) continue;
      sb.writeln('${t.$1}：${t.$2}');
    }
    return sb.toString();
  }

  /// 构造完整的请求消息体。
  static List<Map<String, String>> buildMessages(String transcript) => [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': '对话记录：\n$transcript\n\n请提炼记忆条目。'},
      ];

  /// 判断模型输出是否是一条有效记忆（排除"无"、空、明显续写对话的情况）。
  static bool isValid(String text) {
    final t = text.trim();
    if (t.isEmpty) return false;
    if (t == '无' || t == '"无"' || t == '（无）' || t == '- 无') return false;
    if (t.length < 2) return false;
    return true;
  }

  /// 清理输出：去掉引号、代码块标记，去掉"记忆："之类前缀，保留条目文本。
  static String clean(String text) {
    var t = text.trim();
    if (t.startsWith('```')) {
      final i = t.indexOf('\n');
      if (i >= 0) t = t.substring(i + 1);
      if (t.endsWith('```')) t = t.substring(0, t.length - 3);
      t = t.trim();
    }
    const prefixes = ['记忆条目：', '记忆：', '提炼结果：', '结果：'];
    for (final p in prefixes) {
      if (t.startsWith(p)) t = t.substring(p.length).trim();
    }
    return t;
  }
}
