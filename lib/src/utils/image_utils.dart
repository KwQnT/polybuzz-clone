import 'dart:typed_data';
import 'dart:ui' as ui;

/// 把任意受支持的图片字节转换为 PNG 字节。
/// 转换失败（格式不支持/数据损坏）返回 null。
Future<Uint8List?> convertImageToPng(Uint8List bytes) async {
  if (bytes.isEmpty) return null;
  // 本身已是 PNG 直接返回
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    return bytes;
  }
  try {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (data == null) return null;
    return data.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}
