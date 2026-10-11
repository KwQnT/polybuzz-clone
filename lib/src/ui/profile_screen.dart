import 'package:flutter/material.dart';
import 'personal_info_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tab = 0;
  final _tabs = ['Персонажи', 'Веб-комиксы', 'Галерея', 'Коллекция'];

  String _userName = 'Чико';
  String _subscription = 'Нет';
  int _coins = 15;
  int _opals = 0;

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(milliseconds: 1200),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _subscribe(String plan) {
    setState(() => _subscription = plan);
    _toast('$plan активирован');
  }

  Future<void> _openPersonalInfo() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => PersonalInfoScreen(initialName: _userName)),
    );
    if (result != null && result['name'] != null) {
      setState(() => _userName = result['name']!);
    }
  }

  void _openBuyCoins() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A22),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            const Text('Покупка монет', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _packageTile(ctx, 100, '99 ₽', null),
            _packageTile(ctx, 500, '399 ₽', '+50'),
            _packageTile(ctx, 1000, '699 ₽', '+150'),
            _packageTile(ctx, 5000, '2990 ₽', '+1000'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _packageTile(BuildContext ctx, int coins, String price, String? bonus) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.pop(ctx);
          setState(() => _coins += coins);
          _toast('+$coins монет');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFF25252E), borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              const Icon(Icons.monetization_on_outlined, color: Color(0xFFE8C97B), size: 26),
              const SizedBox(width: 12),
              Text('$coins монет', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              if (bonus != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF7B6CF6), borderRadius: BorderRadius.circular(6)),
                  child: Text(bonus, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
              const Spacer(),
              Text(price, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  void _openFreeCoins() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A22),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            const Text('Зарабатывайте бесплатно', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _taskTile(ctx, 'Посмотреть рекламу', 50, Icons.play_circle_outline),
            _taskTile(ctx, 'Подписаться на канал', 100, Icons.subscriptions_outlined),
            _taskTile(ctx, 'Пригласить друга', 500, Icons.person_add_alt),
            _taskTile(ctx, 'Оценить приложение', 200, Icons.star_outline),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _taskTile(BuildContext ctx, String title, int reward, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.pop(ctx);
          setState(() => _coins += reward);
          _toast('+$reward монет');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFF25252E), borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF7B6CF6), size: 26),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8C97B), borderRadius: BorderRadius.circular(8)),
                child: Text('+$reward', style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.3, -0.8),
            radius: 1.4,
            colors: [Color(0xFF2A1A4D), Color(0xFF0E0E12)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              // Верхняя панель
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _topIcon(Icons.calendar_today_outlined, hasDot: true, onTap: () {}),
                    const SizedBox(width: 16),
                    _topIcon(Icons.mail_outline, hasDot: false, onTap: () {}),
                    const SizedBox(width: 16),
                    _topIcon(Icons.settings_outlined, hasDot: false, onTap: _openPersonalInfo),
                  ],
                ),
              ),

              // Аватар + имя
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: InkWell(
                  onTap: _openPersonalInfo,
                  child: Row(
                    children: [
                      Container(
  width: 56, height: 56,
  decoration: const BoxDecoration(color: Color(0xFF2A2A33), shape: BoxShape.circle),
  clipBehavior: Clip.antiAlias,
  child: _avatarPath.isNotEmpty
      ? Image.file(File(_avatarPath), fit: BoxFit.cover)
      : const Icon(Icons.person, color: Colors.white54, size: 32),
),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_userName,
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            const Row(
                              children: [
                                Text('461', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                                SizedBox(width: 4),
                                Text('Подписчики', style: TextStyle(color: Colors.white54, fontSize: 12)),
                                SizedBox(width: 10),
                                Text('0', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                                SizedBox(width: 4),
                                Text('Подписки', style: TextStyle(color: Colors.white54, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white54, size: 24),
                    ],
                  ),
                ),
              ),

              // Подписки
              SizedBox(
                height: 190,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _subCard('Poly Ultimate', 'Постоянная память + все преимущества Premium',
                        const [Color(0xFF7B3FA0), Color(0xFF3D1F5C)], const Color(0xFFE8B7F0), 'Подписаться',
                        _subscription == 'Poly Ultimate', () => _subscribe('Poly Ultimate')),
                    const SizedBox(width: 12),
                    _subCard('Poly Premium', 'Passion и другие популярные модели',
                        const [Color(0xFF8B6F1F), Color(0xFF3D2F0F)], const Color(0xFFE8C97B), 'Бесплатная пробная версия',
                        _subscription == 'Poly Premium', () => _subscribe('Poly Premium')),
                    const SizedBox(width: 12),
                    _subCard('Poly Basic', 'Без рекламы и с долгой памятью',
                        const [Color(0xFF3D2F7B), Color(0xFF1F1F3D)], const Color(0xFFB7B7F0), 'Бесплатная пробная версия',
                        _subscription == 'Poly Basic', () => _subscribe('Poly Basic')),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Монеты
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A22), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on_outlined, color: Colors.white, size: 28),
                          const SizedBox(width: 10),
                          const Text('Монеты', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          const Icon(Icons.monetization_on, color: Color(0xFFE8C97B), size: 18),
                          const SizedBox(width: 4),
                          Text('$_coins', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _coinButton('Покупка', '-87%', _openBuyCoins, false)),
                          const SizedBox(width: 8),
                          Expanded(child: _coinButton('Зарабатывайте бесплатно', null, _openFreeCoins, true)),
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
                    setState(() => _opals += 1);
                    _toast('+1 опал');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF3D2F7B), Color(0xFF1F1F3D)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.diamond_outlined, color: Colors.white, size: 24),
                        const SizedBox(width: 10),
                        const Text('Опалы', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        const Icon(Icons.diamond, color: Color(0xFFB7B7F0), size: 16),
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
                  decoration: BoxDecoration(color: const Color(0xFF1A1A22), borderRadius: BorderRadius.circular(16)),
                  child: const Row(
                    children: [
                      Icon(Icons.how_to_reg, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text('Центр Создателя', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _topIcon(IconData icon, {required bool hasDot, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          if (hasDot)
            Positioned(
              right: -2, top: -2,
              child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle)),
            ),
        ],
      ),
    );
  }

  Widget _subCard(String title, String subtitle, List<Color> colors, Color buttonColor, String buttonText, bool isActive, VoidCallback onTap) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        border: isActive ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.white, size: 22),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 3),
          const Spacer(),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(20)),
              child: Text(buttonText, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coinButton(String label, String? badge, VoidCallback onTap, bool hasDot) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF25252E), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Text(badge, style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
            if (hasDot)
              Container(
                width: 6, height: 6, margin: const EdgeInsets.only(left: 4),
                decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
