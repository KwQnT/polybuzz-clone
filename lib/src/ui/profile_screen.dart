import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tab = 0;
  final _tabs = ['Персонажи', 'Веб-комиксы', 'Галерея', 'Коллекция'];

  bool _loggedIn = false;
  String _subscription = 'Нет';
  int _coins = 0;
  int _opals = 0;

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _login() {
    setState(() => _loggedIn = true);
    _toast('Вход выполнен');
  }

  void _subscribe(String plan) {
    setState(() => _subscription = plan);
    _toast('$plan активирован');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // Верхняя панель
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: InkWell(
                onTap: _loggedIn ? null : _login,
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(color: Color(0xFF2A2A33), shape: BoxShape.circle),
                      child: Icon(_loggedIn ? Icons.person : Icons.person_outline,
                          color: Colors.white54, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_loggedIn ? 'Артём' : 'Войти',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                    if (!_loggedIn)
                      const Icon(Icons.chevron_right, color: Colors.white54, size: 22),
                  ],
                ),
              ),
            ),
            if (_subscription != 'Нет')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF7B3FA0), Color(0xFF3D1F5C)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text('$_subscription активен',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // Poly Ultimate
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _subscriptionCard(
                title: 'Poly Ultimate',
                subtitle: 'Постоянная память + все преимущества Premium',
                gradient: const [Color(0xFF7B3FA0), Color(0xFF3D1F5C)],
                buttonText: 'Подписаться',
                buttonColor: const Color(0xFFE8B7F0),
                onTap: () => _subscribe('Poly Ultimate'),
              ),
            ),
            const SizedBox(height: 12),
            // Poly Premium
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _subscriptionCard(
                title: 'Poly Premium',
                subtitle: 'Passion и другие популярные модели',
                gradient: const [Color(0xFF8B6F1F), Color(0xFF3D2F0F)],
                buttonText: 'Бесплатная пробная версия',
                buttonColor: const Color(0xFFE8C97B),
                onTap: () => _subscribe('Poly Premium'),
              ),
            ),
            const SizedBox(height: 12),
            // Poly Basic
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _subscriptionCard(
                title: 'Poly Basic',
                subtitle: 'Без рекламы и с долгой памятью',
                gradient: const [Color(0xFF3D2F7B), Color(0xFF1F1F3D)],
                buttonText: 'Бесплатная пробная версия',
                buttonColor: const Color(0xFFB7B7F0),
                onTap: () => _subscribe('Poly Basic'),
              ),
            ),
            const SizedBox(height: 20),

            // Монеты
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        const Text('Монеты', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('$_coins', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() => _coins += 999999);
                              _toast('+999999 монет');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25252E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Text('Покупка', style: TextStyle(color: Colors.white, fontSize: 13)),
                                  Spacer(),
                                  Text('-87%', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, color: Colors.white54, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() => _coins += 100);
                              _toast('+100 монет');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25252E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Text('Зарабатывайте бесплатно',
                                        style: TextStyle(color: Colors.white, fontSize: 13),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.white54, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Опалы
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  setState(() => _opals += 999999);
                  _toast('+999999 опалов');
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF3D2F7B), Color(0xFF1F1F3D)]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      const Text('Опалы', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text('$_opals', style: const TextStyle(color: Colors.white, fontSize: 14)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Центр Создателя
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person_pin_circle, color: Colors.white, size: 22),
                    SizedBox(width: 8),
                    Text('Центр Создателя',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    Spacer(),
                    Icon(Icons.chevron_right, color: Colors.white54, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Вкладки
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 22),
                itemBuilder: (_, i) {
                  final active = i == _tab;
                  return InkWell(
                    onTap: () => setState(() => _tab = i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_tabs[i],
                            style: TextStyle(
                              color: active ? Colors.white : Colors.white54,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                              fontSize: 14,
                            )),
                        const SizedBox(height: 4),
                        if (active)
                          Container(
                            width: 18, height: 3,
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
            const SizedBox(height: 40),

            // Пустое состояние
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Войдите/зарегистрируйтесь, чтобы получить доступ к информации о данных',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!_loggedIn)
              Center(
                child: OutlinedButton(
                  onPressed: _login,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Войти', style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _subscriptionCard({
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(20)),
              child: Text(buttonText,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
