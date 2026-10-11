import 'package:flutter/material.dart';
import 'character_editor_screen.dart';

class CreateHubScreen extends StatefulWidget {
  const CreateHubScreen({super.key});

  @override
  State<CreateHubScreen> createState() => _CreateHubScreenState();
}

class _CreateHubScreenState extends State<CreateHubScreen> {
  int _tabIndex = 0;
  final tabs = ['Все', 'Изображение', 'Голос', 'Музыка'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя панель
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text('Создать ха́б',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Библиотека',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Вкладки
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 22),
                itemBuilder: (_, i) {
                  final active = i == _tabIndex;
                  return InkWell(
                    onTap: () => setState(() => _tabIndex = i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tabs[i],
                            style: TextStyle(
                              color: active ? Colors.white : Colors.white54,
                              fontSize: 15,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                            )),
                        const SizedBox(height: 4),
                        if (active)
                          Container(
                            width: 20, height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B6CF6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Характер
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Характер',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _hubTile(Icons.add, 'Обычный', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CharacterEditorScreen()));
                  }),
                  const SizedBox(width: 10),
                  _hubTile(Icons.share_outlined, 'Многоцелевой', onTap: () {}),
                  const SizedBox(width: 10),
                  _hubTile(Icons.star_border, 'Тема', onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Более
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Более',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _moreTile(Icons.menu_book, 'Вебтун', isNew: true, onTap: () {})),
                      const SizedBox(width: 10),
                      Expanded(child: _moreTile(Icons.music_note, 'Музыка', isNew: true, onTap: () {})),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _moreTile(Icons.image_outlined, 'Изображение', isNew: false, onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Популярные шаблоны
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Популярные шаблоны',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            const Expanded(
              child: Center(
                child: Text('Ещё нет шаблонов',
                    style: TextStyle(color: Colors.white54, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hubTile(IconData icon, String label, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E28),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 26),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _moreTile(IconData icon, String label, {required bool isNew, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E28),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ),
            if (isNew)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B6CF6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Новое',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}
