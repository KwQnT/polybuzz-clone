import 'package:flutter/material.dart';
import 'create_hub_screen.dart';
import 'explore_screen.dart';
import 'settings_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 80, color: Colors.white24),
                    SizedBox(height: 16),
                    Text('Пока нет чатов',
                        style: TextStyle(color: Colors.white54, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
  color: const Color(0xFF0E0E12),
  padding: const EdgeInsets.only(top: 8, bottom: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.home_outlined, color: Colors.white54, size: 26),
      ),
      const Icon(Icons.chat_bubble, color: Colors.white, size: 26),
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateHubScreen()),
        ),
        child: Container(
          width: 44, height: 44,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.black, size: 28),
        ),
      ),
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ExploreScreen()),
        ),
        child: const Icon(Icons.explore_outlined, color: Colors.white54, size: 26),
      ),
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
        child: const Icon(Icons.person_outline, color: Colors.white54, size: 26),
      ),
    ],
  ),
),
