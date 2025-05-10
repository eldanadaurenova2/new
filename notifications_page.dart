import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': '📅 Бронирование приближается',
      'subtitle': 'Rixos Astana — заезд 20 апреля',
      'category': 'reminder',
      'read': false,
    },
    {
      'title': '🏨 Заселение через 3 дня',
      'subtitle': 'Hilton Astana — 23 апреля',
      'category': 'reminder',
      'read': false,
    },
    {
      'title': '🔥 Скидка 20% на Ritz Almaty',
      'subtitle': 'До 25 апреля!',
      'category': 'offer',
      'read': false,
    },
    {
      'title': '🚀 Добавлена тёмная тема',
      'subtitle': 'Смените в профиле или настройках',
      'category': 'update',
      'read': false,
    },
  ];

  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });

    // Удаляем с анимацией
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          notifications.removeAt(index);
        });
      }
    });
  }

  void clearAll() async {
    for (int i = notifications.length - 1; i >= 0; i--) {
      setState(() {
        notifications[i]['read'] = true;
      });
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          notifications.removeAt(i);
        });
      }
    }
  }

  Widget buildNotificationItem(int index) {
    final item = notifications[index];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: item['read']
          ? const SizedBox.shrink()
          : ListTile(
              key: ValueKey(item['title']),
              leading: const Icon(Icons.notifications_active, color: Colors.blue),
              title: Text(
                item['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['subtitle']),
              trailing: const Icon(Icons.mark_email_read_outlined, size: 18),
              onTap: () => markAsRead(index),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Очистить всё',
              onPressed: clearAll,
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("Нет уведомлений"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) => buildNotificationItem(index),
            ),
    );
  }
}
