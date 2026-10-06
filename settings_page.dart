import 'package:flutter/material.dart';
import 'widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageFrame(
        title: 'Ayarlar',
        child: ListView(
          children: [
            const Text('Okuma Ayarları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Odak modu')),
            const ListTile(title: Text('Varsayılan WPM'), trailing: Text('250')),
            const ListTile(title: Text('Yazı boyutu'), trailing: Text('Orta')),
            const ListTile(title: Text('Tema'), trailing: Text('Koyu')),
            const Divider(),
            const Text('Uygulama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Bildirimler')),
            const ListTile(title: Text('Dil'), trailing: Text('Türkçe')),
          ],
        ),
      ),
    );
  }
}
