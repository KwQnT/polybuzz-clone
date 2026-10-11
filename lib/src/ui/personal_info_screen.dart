import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String initialName;
  const PersonalInfoScreen({super.key, required this.initialName});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  String _gender = 'Мужской';
  bool _genderPublic = false;
  DateTime _birthday = DateTime(2001, 7, 20);
  String _userId = '3202428735';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    // Показываем кастомный барабан снизу
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: const Color(0xFF1A1A22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        DateTime temp = _birthday;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 340,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
                      ),
                      const Text('День рождения',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, temp),
                        child: const Text('Готово', style: TextStyle(color: Color(0xFF7B6CF6))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        // День
                        Expanded(
                          child: _wheel(
                            items: List.generate(31, (i) => '${i + 1}'),
                            initial: temp.day - 1,
                            onChanged: (i) {
                              final d = i + 1;
                              final maxDay = DateTime(temp.year, temp.month + 1, 0).day;
                              setModalState(() {
                                temp = DateTime(temp.year, temp.month, d > maxDay ? maxDay : d);
                              });
                            },
                          ),
                        ),
                        // Месяц
                        Expanded(
                          child: _wheel(
                            items: const ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
                            initial: temp.month - 1,
                            onChanged: (i) => setModalState(() => temp = DateTime(temp.year, i + 1, temp.day)),
                          ),
                        ),
                        // Год
                        Expanded(
                          child: _wheel(
                            items: List.generate(127, (i) => '${2026 - i}'),
                            initial: 2026 - temp.year,
                            onChanged: (i) => setModalState(() => temp = DateTime(2026 - i, temp.month, temp.day)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (picked != null) {
      setState(() => _birthday = picked);
    }
  }

  Widget _wheel({required List<String> items, required int initial, required ValueChanged<int> onChanged}) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 40,
      diameterRatio: 1.5,
      perspective: 0.005,
      controller: FixedExtentScrollController(initialItem: initial),
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, i) => Center(
          child: Text(items[i],
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }

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
        title: const Text('Личная информация',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Аватар
          Center(
            child: Stack(
              children: [
                Container(
                  width: 110, height: 110,
                  decoration: const BoxDecoration(color: Color(0xFF2A2A33), shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Colors.white54, size: 60),
                ),
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.black, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('ID: $_userId  /  IP: FR',
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          const SizedBox(height: 24),

          // Имя пользователя
          const Text('Имя пользователя', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            maxLength: 25,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              counterStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1A22),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const Text(
            'Пожалуйста, введите 3–25 символов. Только буквы, смайлы, цифры, подчеркивание, дефис, апостроф, запятая и пробел.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Пол
          Row(
            children: [
              const Text('Пол', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              const Text('Публично показывать', style: TextStyle(color: Colors.white54, fontSize: 12)),
              Switch(
                value: _genderPublic,
                onChanged: (v) => setState(() => _genderPublic = v),
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF5A4FCF),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _genderButton('Мужской'),
              const SizedBox(width: 8),
              _genderButton('Женский'),
              const SizedBox(width: 8),
              _genderButton('Невоичный'),
            ],
          ),
          const SizedBox(height: 20),

          // День рождения
          const Text('День рождения (Можно редактировать один раз)',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickBirthday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text('${_birthday.day} ${_monthName(_birthday.month)} ${_birthday.year}',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white38, size: 14),
              SizedBox(width: 6),
              Expanded(
                child: Text('Информация хранится надежно. Не публикуется публично.',
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Био
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: 'Био ', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                TextSpan(text: '(Необязательный)', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            maxLines: 4,
            maxLength: 100,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Заполните свою биографию, чтобы другие могли\nузнать вас лучше!',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
              counterStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1A22),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),

          // Кнопка Сохранить
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text.trim().isEmpty ? 'Артём' : _nameController.text.trim(),
                  'gender': _gender,
                  'birthday': _birthday.toIso8601String(),
                  'bio': _bioController.text.trim(),
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B6CF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: const Text('Сохранить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderButton(String label) {
    final active = _gender == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _gender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2A2A3D) : const Color(0xFF1A1A22),
            borderRadius: BorderRadius.circular(12),
            border: active ? Border.all(color: const Color(0xFF7B6CF6), width: 1.5) : null,
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.white70, fontSize: 13)),
        ),
      ),
    );
  }

  String _monthName(int m) {
    const months = ['Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'];
    return months[m - 1];
  }
}
