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
      
