import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // Поиск
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
            ),

            // Баннер «В разработке»
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A1F3D), Color(0xFF1A1A28)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.construction, color: Colors.white54, size: 44),
                    SizedBox(height: 12),
                    Text('В разработке',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Скоро здесь появятся новинки',
                        style: TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Рейтинг персонажей
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Рейтинг персонажей 🏆',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                  Spacer(),
                  Text('В разработке',
                      style: TextStyle(color: Colors.white38, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A22),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events_outlined, color: Colors.white24, size: 40),
                  SizedBox(height: 10),
                  Text('Нет игроков',
                      style: TextStyle(color: Colors.white54, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Подборки
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Подборки',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A22),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.collections_bookmark_outlined, color: Colors.white24, size: 40),
                  SizedBox(height: 10),
                  Text('В разработке',
                      style: TextStyle(color: Colors.white54, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      color: const Color(0xFF0E0E12),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Дом
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.home_outlined, color: Colors.white54, size: 26),
          ),
          // 2. Чаты (заглушка)
          const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 26),
          // 3. Плюсик
          Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.black, size: 28),
          ),
          // 4. Исследовать (активна)
          const Icon(Icons.explore, color: Colors.white, size: 26),
          // 5. Профиль
          const Icon(Icons.person_outline, color: Colors.white54, size: 26),
        ],
      ),
    );
  }
}
