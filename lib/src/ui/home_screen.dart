import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../utils/file_utils.dart';
import 'character_editor_screen.dart';
import 'chat_screen.dart';
import 'chats_screen.dart';
import 'create_hub_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'usage_help_screen.dart';
import 'group_create_screen.dart';
import 'group_chat_screen.dart';
import 'model_settings_screen.dart';
import 'widgets/avatars.dart';
import 'widgets/character_actions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _listMode = true;

  List<_HomeItem> _items(AppState state) {
    final items = <_HomeItem>[
      for (final g in state.groups) _HomeItem.group(g),
      for (final c in state.characters) _HomeItem.character(c),
    ];
    items.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.lastActivity.compareTo(a.lastActivity);
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = _items(state);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _confirmExit();
      },
      child: _homeBody(state, items),
    );
  }

  Future<void> _confirmExit() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A22),
        title: const Text('Выход', style: TextStyle(color: Colors.white)),
        content: const Text('Вы уверены, что хотите выйти?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Выйти', style: TextStyle(color: Color(0xFF7B6CF6))),
          ),
        ],
      ),
    );
    if (ok == true) SystemNavigator.pop();
  }

  Future<void> _importCharacterCard(BuildContext context) async {
    final r = await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
    if (r == null || r.files.isEmpty) return;
    final f = r.files.first;
    Uint8List? bytes = f.bytes;
    if ((bytes == null || bytes.isEmpty) && (f.path?.isNotEmpty ?? false)) {
      try {
        bytes = await File(f.path!).readAsBytes();
      } catch (_) {}
    }
    if (bytes == null || bytes.isEmpty) {
      _toast('Не удалось прочитать файл');
      return;
    }
    final state = context.read<AppState>();
    final isImage = bytes.length >= 8 &&
        ((bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) ||
            (bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46));
    String? avatarPath;
    if (isImage) {
      final ext = bytes[0] == 0x89 ? 'png' : 'webp';
      avatarPath = await saveBytesToApp(bytes, ext);
    }
    final created = await state.importCharacterCard(bytes, avatarPath: avatarPath);
    if (created == null) {
      _toast('Не удалось распознать карточку');
    } else {
      _toast('Импортирован персонаж «${created.name}»');
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ── ГЛАВНЫЙ ЭКРАН ──
  Widget _homeBody(AppState state, List<_HomeItem> items) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _pbTopTabs(),
            _pbSearchBar(),
            _pbChipsRow(),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? _pbEmptyState()
                  : (_listMode
                      ? _listView(context, state, items)
                      : _gridView(context, state, items)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _pbBottomNav(),
    );
  }

  Widget _pbTopTabs() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Подписки', style: TextStyle(color: Colors.white54, fontSize: 17)),
          const SizedBox(width: 28),
          Column(
            children: const [
              Text('Исследовать',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              SizedBox(
                width: 24,
                height: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pbSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E24),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Row(
          children: [
            SizedBox(width: 14),
            Icon(Icons.search, color: Colors.white54, size: 22),
            SizedBox(width: 8),
            Text('Поиск', style: TextStyle(color: Colors.white54, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _pbChipsRow() {
    final chips = ['Для вас', 'От врагов к возлюбленным', 'Кумиры и звёзды', 'Вебтун'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, i) {
          final selected = i == 0;
          return Center(
            child: Text(
              chips[i],
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pbEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline, size: 72, color: Colors.white24),
          SizedBox(height: 12),
          Text('Ещё нет персонажей', style: TextStyle(color: Colors.white54, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _pbBottomNav() {
    return Container(
      color: const Color(0xFF0E0E12),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.home_filled, color: Colors.white, size: 26),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatsScreen()),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 26),
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('99+',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateHubScreen()),
            ),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.black, size: 28),
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExploreScreen()),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.explore_outlined, color: Colors.white54, size: 26),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white54, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _listView(BuildContext context, AppState state, List<_HomeItem> items) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        if (it.group != null) {
          return _GroupTile(group: it.group!);
        }
        return _CharacterTile(character: it.character!);
      },
    );
  }

  Widget _gridView(BuildContext context, AppState state, List<_HomeItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.86,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        if (it.group != null) {
          return _GroupCardGrid(group: it.group!);
        }
        return _CharacterCardGrid(character: it.character!);
      },
    );
  }
}

class _HomeItem {
  final Character? character;
  final ChatGroup? group;
  _HomeItem.character(this.character) : group = null;
  _HomeItem.group(this.group) : character = null;
  bool get pinned => character?.pinned ?? group?.pinned ?? false;
  int get createdAt => character?.createdAt ?? group?.createdAt ?? 0;
  int get lastActivity => character?.lastActivity ?? group?.lastActivity ?? createdAt;
}

class _CharacterTile extends StatelessWidget {
  final Character character;
  const _CharacterTile({required this.character});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: buildCharacterAvatar(context, character, 44),
      title: Text(character.name, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white)),
      subtitle: const Text('Открыть чат', style: TextStyle(color: Colors.white54)),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatScreen(characterId: character.id)),
      ),
      onLongPress: () => showCharacterMenu(context, character),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final ChatGroup group;
  const _GroupTile({required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: buildGroupAvatar(context, group, 44),
      title: Text(group.name, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white)),
      subtitle: const Text('Групповой чат', style: TextStyle(color: Colors.white54)),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: group.id)),
      ),
    );
  }
}

class _CharacterCardGrid extends StatelessWidget {
  final Character character;
  const _CharacterCardGrid({required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatScreen(characterId: character.id)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF1E1E24),
                alignment: Alignment.center,
                child: buildCharacterAvatar(context, character, 64),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(character.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCardGrid extends StatelessWidget {
  final ChatGroup group;
  const _GroupCardGrid({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupChatScreen(groupId: group.id)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF1E1E24),
                alignment: Alignment.center,
                child: buildGroupAvatar(context, group, 64),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(group.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
