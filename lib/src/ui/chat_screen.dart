import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../services/chat_api.dart';

class ChatScreen extends StatefulWidget {
  final String characterId;
  final String? initialSearchTargetId;
  const ChatScreen({super.key, required this.characterId, this.initialSearchTargetId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _sending = false;
  Character? _character;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCharacter());
  }

  void _loadCharacter() {
    final state = context.read<AppState>();
    if (state.characters.isEmpty) {
      setState(() {});
      return;
    }
    final ch = state.characters.firstWhere(
      (c) => c.id == widget.characterId,
      orElse: () => state.characters.first,
    );
    setState(() {
      _character = ch;
      _messages.add({'role': 'system', 'content': _buildSystemPrompt(ch)});
      if (ch.greeting.isNotEmpty) {
        _messages.add({'role': 'assistant', 'content': ch.greeting});
      }
    });
  }

  String _buildSystemPrompt(Character c) {
    final parts = <String>['Ты — ${c.name}.'];
    if (c.persona.isNotEmpty) parts.add('Роль: ${c.persona}');
    if (c.personality.isNotEmpty) parts.add('Характер: ${c.personality}');
    if (c.tone.isNotEmpty) parts.add('Тон речи: ${c.tone}');
    if (c.background.isNotEmpty) parts.add('Предыстория: ${c.background}');
    parts.add('Оставайся в роли всегда. Отвечай на русском. Описания действий выделяй *звёздочками*.');
    return parts.join('\n');
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _sending = true;
    });
    _controller.clear();
    _scrollToBottom();

    final reply = await ChatApi.sendMessage(_messages);

    setState(() {
      _messages.add({'role': 'assistant', 'content': reply});
      _sending = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_character == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E0E12),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final visible = _messages.where((m) => m['role'] != 'system').toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_character!.name,
            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: visible.length,
              itemBuilder: (context, i) {
                final msg = visible[i];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF7B6CF6) : const Color(0xFF1E1E24),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['content'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_sending)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54)),
                  SizedBox(width: 10),
                  Text('печатает...', style: TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              color: const Color(0xFF0E0E12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Сообщение...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF1E1E24),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _send,
                    child: Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(color: Color(0xFF7B6CF6), shape: BoxShape.circle),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
