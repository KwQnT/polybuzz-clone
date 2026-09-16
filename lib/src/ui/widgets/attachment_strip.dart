import 'dart:io';
import 'package:flutter/material.dart';

/// 待发送的附件（图片或文件）。发送前只展示在输入框上方，不发送。
class PendingAttachment {
  final String path; // 本地路径（图片可为临时路径）
  final String name; // 展示名
  final bool isImage;
  const PendingAttachment({required this.path, required this.name, required this.isImage});
}

/// 输入框上方的附件预览条：图片显示缩略图，文件显示图标+名称，可单个删除。
class AttachmentStrip extends StatelessWidget {
  final List<PendingAttachment> items;
  final ValueChanged<int> onRemove;
  final double scale;
  const AttachmentStrip({
    super.key,
    required this.items,
    required this.onRemove,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (int i = 0; i < items.length; i++)
            _chip(context, items[i], i, scheme),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, PendingAttachment a, int i, ColorScheme scheme) {
    const double h = 52;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: h,
          constraints: const BoxConstraints(maxWidth: 150),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: a.isImage && File(a.path).existsSync()
                    ? Image.file(File(a.path), width: h - 6, height: h - 6, fit: BoxFit.cover)
                    : Container(
                        width: h - 6,
                        height: h - 6,
                        color: scheme.surfaceContainerHighest,
                        child: Icon(a.isImage ? Icons.image : Icons.insert_drive_file,
                            size: 22, color: scheme.onSurfaceVariant),
                      ),
              ),
              const SizedBox(width: 5),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 74),
                child: Text(
                  a.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10 * scale, color: scheme.onSurface),
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
        Positioned(
          right: -5,
          top: -5,
          child: GestureDetector(
            onTap: () => onRemove(i),
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: scheme.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
