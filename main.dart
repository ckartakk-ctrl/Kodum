import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'storage_service.dart';
import 'home_page.dart';
import 'library_page.dart';
import 'reader_page.dart';
import 'stats_page.dart';
import 'profile_page.dart';

void main() => runApp(const FocusReadApp());

class FocusReadApp extends StatelessWidget {
  const FocusReadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FocusRead',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF06111F),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF239BFF), brightness: Brightness.dark),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  bool loading = true;
  Map<String, int> progress = {};

  final books = const [
    Book('Suç ve Ceza', 'Fyodor Dostoyevski', Icons.menu_book),
    Book('Sapiens', 'Yuval Noah Harari', Icons.auto_stories),
    Book('Düşün ve Zengin Ol', 'Napoleon Hill', Icons.book),
    Book('İnsan Ne ile Yaşar', 'Lev Tolstoy', Icons.import_contacts),
    Book('1984', 'George Orwell', Icons.library_books),
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final map = await StorageService.loadAllProgress(books.map((b) => b.title).toList());
    if (!mounted) return;
    setState(() {
      progress = map;
      loading = false;
    });
  }

  Future<void> _openBook(Book book) async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => ReaderPage(title: book.title, bookKey: book.title)),
    );
    if (result != null && mounted) {
      setState(() => progress[book.title] = result);
    }
  }

  Future<void> _openImported(String title, String text) async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => ReaderPage(title: title, text: text, bookKey: title)),
    );
    if (result != null && mounted) {
      setState(() => progress[title] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final pages = [
      HomePage(books: books, progress: progress, onContinue: () => setState(() => index = 2)),
      LibraryPage(books: books, progress: progress, onOpenBook: _openBook, onImported: _openImported),
      const ReaderPage(),
      const StatsPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF08182A),
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.library_books_outlined), selectedIcon: Icon(Icons.library_books), label: 'Kitaplık'),
          NavigationDestination(icon: Icon(Icons.speed_outlined), selectedIcon: Icon(Icons.speed), label: 'Oku'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'İstatistik'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
