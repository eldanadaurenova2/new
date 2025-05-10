import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  bool isDarkTheme = false;
  bool notificationsEnabled = true;
  String selectedLanguage = 'Русский';

  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Создаем интервалы для последовательной анимации элементов
    _slideAnimations = List.generate(5, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.1 * index, 0.1 * index + 0.5, curve: Curves.easeOut),
        ),
      );
    });

    _fadeAnimations = List.generate(5, (index) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.1 * index, 0.1 * index + 0.5, curve: Curves.easeIn),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedItem({required int index, required Widget child}) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _animatedItem(
            index: 0,
            child: const Text(
              'Предпочтения',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          _animatedItem(
            index: 1,
            child: ListTile(
              title: const Text("Язык"),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'Русский', child: Text('Русский')),
                  DropdownMenuItem(value: 'English', child: Text('English')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
              ),
            ),
          ),
          _animatedItem(
            index: 2,
            child: SwitchListTile(
              title: const Text('Уведомления'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          _animatedItem(
            index: 3,
            child: SwitchListTile(
              title: const Text('Тёмная тема'),
              value: isDarkTheme,
              onChanged: (value) {
                setState(() {
                  isDarkTheme = value;
                });
              },
            ),
          ),
          const Divider(height: 32),
          _animatedItem(
            index: 4,
            child: const ListTile(
              title: Text("О приложении"),
              subtitle: Text("Hotel Booking v1.0\nРазработано студентом AITU ❤️"),
            ),
          ),
        ],
      ),
    );
  }
}
