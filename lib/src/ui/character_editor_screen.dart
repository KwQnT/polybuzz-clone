import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class CharacterEditorScreen extends StatefulWidget {
  final Character? character;
  const CharacterEditorScreen({super.key, this.character});

  @override
  State<CharacterEditorScreen> createState() => _CharacterEditorScreenState();
}

class _CharacterEditorScreenState extends State<CharacterEditorScreen> {
  final _nameController = TextEditingController();
  final _introController = TextEditingController();
  final _greetingController = TextEditingController();
  final _greetingFocus = FocusNode();

  String _gender = 'Мужской';
  String _visibility = 'Публичный';
  bool _agreed = true;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    if (widget.character != null) {
      _nameController.text = widget.character!.name;
      _introController.text = widget.character!.personality;
      _greetingController.text = widget.character!.greeting;
      _avatarPath = widget.character!.avatar.isNotEmpty ? widget.character!.avatar : null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _introController.dispose();
    _greetingController.dispose();
    _greetingFocus.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (file != null) setState(() => _avatarPath = file.path);
  }

  void _insertIntoGreeting(String text) {
    final current = _greetingController.text;
    final selection = _greetingController.selection;
    final cursor = selection.isValid ? selection.start : current.length;
    final newText = current.substring(0, cursor) + text + current.substring(cursor);
    _greetingController.text = newText;
    _greetingController.selection = TextSelection.collapsed(offset: cursor + text.length);
    _greetingFocus.requestFocus();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1500),
    ));
  }

  void _saveDraft() => _toast('Черновик сохранён');
  void _generateAi() => _toast('ИИ-генерация скоро');

  Future<void> _save() async {
    if (_nameController.text.trim().length < 3) {
      _toast('Имя должно быть от 3 до 36 символов');
      return;
    }

    final state = context.read<AppState>();
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final ch = Character(
      id: widget.character?.id ?? id,
      name: _nameController.text.trim(),
      avatar: _avatarPath ?? '',
      persona: '',
      personality: _introController.text.trim(),
      tone: '',
      background: '',
      greeting: _greetingController.text.trim(),
      chatBackground: '',
      replyStyle: 'default',
      worldbookIds: [],
      settings: {},
      userName: '',
    );

    if (widget.character == null) {
      await state.addCharacter(ch);
    } else {
      await state.updateCharacter(ch);
    }

    if (mounted) {
      _toast('Персонаж сохранён');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Основная информация 1/2',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Colors.white, size: 22),
            onPressed: _saveDraft,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Label('Аватар', required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A33),
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: _avatarPath != null
                    ? Image.file(File(_avatarPath!), fit: BoxFit.cover)
                    : const Icon(Icons.face, color: Colors.white24, size: 60),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _avatarButton(Icons.auto_awesome, 'Создать ИИ', _generateAi),
                    const SizedBox(height: 8),
                    _avatarButton(Icons.upload_outlined, 'Загрузить', _pickAvatar),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _Label('Имя', required: true),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            maxLength: 36,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Назовите своего персонажа',
              hintStyle: const TextStyle(color: Colors.white38),
              counterStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1A22),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const _HintText('Пожалуйста, введите от 3 до 36 символов.'),
          const SizedBox(height: 20),
          const _Label('Пол', required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _genderBtn('Мужской'),
              const SizedBox(width: 8),
              _genderBtn('Женский'),
              const SizedBox(width: 8),
              _genderBtn('Небинарный'),
            ],
          ),
          const SizedBox(height: 24),
          const _Label('Вступление.', required: true, suffix: '(публично видно)'),
          const SizedBox(height: 8),
          TextField(
            controller: _introController,
            maxLines: 4,
            maxLength: 1000,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'например, {char} — доблестный рыцарь...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
              counterStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1A22),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const _HintText('Дайте вашему персонажу краткое описание.'),
          const SizedBox(height: 20),
          const _Label('Приветствия', required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _markupButton('* Text *', () => _insertIntoGreeting('**')),
              const SizedBox(width: 8),
              _markupButton('Перс.', () => _insertIntoGreeting('{char}')),
              const SizedBox(width: 8),
              _markupButton('Пользователь', () => _insertIntoGreeting('{user}')),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _greetingController,
            focusNode: _greetingFocus,
            maxLines: 5,
            maxLength: 3000,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'например *Тускло освещенная комната...*',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
              counterStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1A22),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const _HintText('Создайте приветствие.'),
          const SizedBox(height: 12),
          Center(
            child: InkWell(
              onTap: _generateAi,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Генерировать', style: TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(width: 8),
                    const Icon(Icons.monetization_on, color: Color(0xFFE8C97B), size: 18),
                    const SizedBox(width: 4),
                    const Text('200', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const _Label('Разрешение', required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _radio('Публичный', _visibility == 'Публичный', () => setState(() => _visibility = 'Публичный')),
              const SizedBox(width: 24),
              _radio('Приватный', _visibility == 'Приватный', () => setState(() => _visibility = 'Приватный')),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B6CF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: const Text('Сохранить и Далее',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _avatarButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _markupButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ),
    );
  }

  Widget _genderBtn(String label) {
    final active = _gender == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _gender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2A2A3D) : const Color(0xFF1A1A22),
            borderRadius: BorderRadius.circular(10),
            border: active ? Border.all(color: const Color(0xFF7B6CF6), width: 1.5) : null,
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.white70, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _radio(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: active ? const Color(0xFF7B6CF6) : Colors.white54, width: 2),
            ),
            child: active
                ? Center(
                    child: Container(
                      width: 10, height: 10,
                      decoration: const BoxDecoration(color: Color(0xFF7B6CF6), shape: BoxShape.circle),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final bool required;
  final String? suffix;
  const _Label(this.text, {this.required = false, this.suffix});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          if (required)
            const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFE53935), fontSize: 15, fontWeight: FontWeight.w700)),
          if (suffix != null)
            TextSpan(text: ' $suffix', style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HintText extends StatelessWidget {
  final String text;
  const _HintText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.white38, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
