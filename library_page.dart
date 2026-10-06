import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets.dart';
import 'import_service.dart';

class LibraryPage extends StatefulWidget {
  final List<Book> books;
  final Map<String, int> progress;
  final void Function(Book book) onOpenBook;
  final void Function(String title, String text) onImported;
  const LibraryPage({
    super.key,
    required this.books,
    required this.progress,
    required this.onOpenBook,
    required this.onImported,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String query = '';
  bool importing = false;

  Future<void> _import() async {
    setState(() => importing = true);
    try {
      final result = await ImportService.pickAndImport();
      if (result != null) {
        widget.onImported(result.title, result.text);
      }
    } on ImportException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Beklenmeyen bir hata oluştu: $e')));
    } finally {
      if (mounted) setState(() => importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.books.where((b) => b.title.toLowerCase().contains(query.toLowerCase())).toList();
    return PageFrame(
      title: 'Kitaplık',
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Kitap, yazar veya dosya ara...',
              filled: true,
              fillColor: const Color(0xFF10243A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Chip(label: Text('Tümü')),
              const SizedBox(width: 8),
              TextButton(
                onPressed: importing ? null : _import,
                child: importing
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('+ Dosya Yükle (PDF/EPUB/TXT)'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10),
              itemBuilder: (_, i) => BookTile(
                book: filtered[i],
                progress: widget.progress[filtered[i].title] ?? 0,
                onTap: () => widget.onOpenBook(filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
