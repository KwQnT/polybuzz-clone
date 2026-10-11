import 'package:flutter/material.dart';

class ModelSettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<ModelSettingsScreen> createState() => _ModelSettingsScreenState();
}

class _ModelSettingsScreenState extends State<ModelSettingsScreen> {
  String _language = 'RU';
  bool _fontSize = true;
  bool _voice = true;
  bool _notifications = true;
  bool _sendOnEnter = true;
  bool _pureMode = false;
  bool _parentalControl = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Настройки',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildTile(
            title: 'Язык',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_language, style: const TextStyle(color: Colors.white70, fontSize: 15)),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
              ],
            ),
            onTap: () => _showLanguageDialog(),
          ),
          _buildSwitchTile(
            title: 'Размер системного шрифта',
            value: _fontSize,
            onChanged: (v) => setState(() => _fontSize = v),
          ),
          _buildSwitchTile(
            title: 'Голосовое воспроизведение',
            value: _voice,
            onChanged: (v) => setState(() => _voice = v),
          ),
          _buildTile(
            title: 'Уведомления',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
            onTap: () {},
          ),
          _buildSwitchTile(
            title: 'Отправляйте сообщения с помощью клавиши Enter.',
            value: _sendOnEnter,
            onChanged: (v) => setState(() => _sendOnEnter = v),
          ),
          const SizedBox(height: 8),
          _buildTile(
            title: 'Счёт',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
            onTap: () {},
          ),
          _buildTile(
            title: 'Промо-код',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
            onTap: () {},
          ),
          _buildSwitchTile(
            title: 'Чистый режим',
            value: _pureMode,
            onChanged: (v) => setState(() => _pureMode = v),
          ),
          _buildSwitchTile(
            title: 'Родительский контроль',
            value: _parentalControl,
            onChanged: (v) => setState(() => _parentalControl = v),
          ),
          _buildTile(
            title: 'Центр безопасности',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
            onTap: () {},
          ),
          _buildTile(
            title: 'Следуйте за Поли',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
            onTap: () {},
          ),
          _buildTile(
            title: 'О нас',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Выйти', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTile({required String title, required Widget trailing, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF5A4FCF),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: const Color(0xFF2A2A33),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A22),
        title: const Text('Язык', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langItem('Русский (RU)', 'RU'),
            _langItem('English (EN)', 'EN'),
            _langItem('Español (ES)', 'ES'),
            _langItem('Français (FR)', 'FR'),
            _langItem('Deutsch (DE)', 'DE'),
          ],
        ),
      ),
    );
  }

  Widget _langItem(String label, String code) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: _language == code ? const Icon(Icons.check, color: Color(0xFF5A4FCF)) : null,
      onTap: () {
        setState(() => _language = code);
        Navigator.pop(context);
      },
    );
  }
}
