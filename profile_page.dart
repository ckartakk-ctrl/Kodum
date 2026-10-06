import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Profil',
      child: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(radius: 28, child: Icon(Icons.person)),
            title: Text('İbrahim K.'),
            subtitle: Text('Tüm özellikler açık'),
          ),
          const SizedBox(height: 20),
          const ListTile(leading: Icon(Icons.menu_book), title: Text('7 Kitap'), subtitle: Text('Kütüphanendeki kitaplar')),
          const ListTile(leading: Icon(Icons.history), title: Text('Okuma Geçmişi')),
          const ListTile(leading: Icon(Icons.favorite_border), title: Text('Favoriler')),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ayarlar'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
    );
  }
}
