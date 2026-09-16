import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../utils/action_text.dart';

/// 查找聊天记录的通用工具：过滤 + 关键词高亮文本构建。
class SearchUtil {
  /// 返回在所有消息里命中 query 的消息（同一条消息多个关键词只算一条）。
  /// 返回顺序：最近的消息在最上面（越靠后创建的越靠前）。
  static List<ChatMessage> search(List<ChatMessage> messages, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final words = q.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return [];
    final hits = messages.where((m) {
      final lower = m.content.toLowerCase();
      return words.any((w) => lower.contains(w));
    }).toList();
    // 最近的排最上
    return hits.reversed.toList();
  }

  /// 构建高亮 [InlineSpan]：命中词显示为主题色，其余正常；用于结果行。
  static List<InlineSpan> highlight(String content, String query, Color hitColor, double scale,
      {Color? normalColor}) {
    final segments = parseActionText(content, isUser: false);
    final words = query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final result = <InlineSpan>[];
    for (final seg in segments) {
      final base = TextStyle(fontSize: 14 * scale, color: normalColor);
      if (seg.isAction) {
        result.add(TextSpan(
          text: seg.text,
          style: base.copyWith(fontStyle: FontStyle.italic, color: hitColor.withValues(alpha: 0.7)),
        ));
        continue;
      }
      result.addAll(_colorWords(seg.text, words, hitColor, base));
    }
    return result;
  }

  static List<TextSpan> _colorWords(String text, List<String> words, Color hit, TextStyle base) {
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    int pos = 0;
    while (pos < text.length) {
      int bestIdx = -1;
      int bestLen = 0;
      for (final w in words) {
        final idx = lower.indexOf(w, pos);
        if (idx >= 0 && (bestIdx == -1 || idx < bestIdx)) {
          bestIdx = idx;
          bestLen = w.length;
        }
      }
      if (bestIdx == -1) {
        spans.add(TextSpan(text: text.substring(pos), style: base));
        break;
      }
      if (bestIdx > pos) {
        spans.add(TextSpan(text: text.substring(pos, bestIdx), style: base));
      }
      spans.add(TextSpan(
        text: text.substring(bestIdx, bestIdx + bestLen),
        style: base.copyWith(color: hit, fontWeight: FontWeight.w600),
      ));
      pos = bestIdx + bestLen;
    }
    return spans;
  }

  /// 计算省略位置：以第一个命中词为参考，保留其两侧上下文（两端省略）。
  /// 支持多关键词（空格分隔）；若都没命中则从开头截断。
  static String ellipsizeAround(String content, String query, {int maxLen = 80}) {
    if (content.length <= maxLen) return content;
    final words = query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final lower = content.toLowerCase();
    // 找最靠前的命中词位置
    int hit = -1;
    for (final w in words) {
      final i = lower.indexOf(w);
      if (i >= 0 && (hit == -1 || i < hit)) hit = i;
    }
    int start;
    if (hit < 0) {
      start = 0;
    } else {
      // 命中词前保留约 1/3 宽度，确保命中词可见
      start = hit - maxLen ~/ 3;
      if (start < 0) start = 0;
      if (start + maxLen > content.length) start = content.length - maxLen;
      if (start < 0) start = 0;
    }
    final end = (start + maxLen).clamp(0, content.length);
    final head = start > 0 ? '…' : '';
    final tail = end < content.length ? '…' : '';
    return '$head${content.substring(start, end)}$tail';
  }
}
