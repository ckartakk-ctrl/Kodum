import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets.dart';

class HomePage extends StatelessWidget {
  final List<Book> books;
  final Map<String, int> progress;
  final VoidCallback onContinue;
  const HomePage({super.key, required this.books, required this.progress, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final continuing = books.first;
    return PageFrame(
      child: ListView(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Color(0xFF11B5FF), Color(0xFF765CFF)]),
                ),
                child: const Icon(Icons.center_focus_strong),
              ),
              const SizedBox(width: 10),
              const Text('FocusRead', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Daha hızlı oku,\ndaha fazlasını keşfet.',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, height: 1.05),
          ),
          const SizedBox(height: 10),
          const Text(
            'Kitapları ve metinleri kelime kelime, odaklanarak oku.',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(17),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Hemen Başla →', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 28),
          const Text('Devam Edilen Kitap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          BookTile(book: continuing, progress: progress[continuing.title] ?? 0),
          const SizedBox(height: 26),
          const Text('Popüler Kitaplar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 145,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => MiniBook(book: books[i]),
            ),
          ),
        ],
      ),
    );
  }
}
