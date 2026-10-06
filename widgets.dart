import 'package:flutter/material.dart';
import 'models.dart';

class PageFrame extends StatelessWidget {
  final Widget child;
  final String? title;
  const PageFrame({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Text(title!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;
  final int progress;
  final VoidCallback? onTap;
  const BookTile({super.key, required this.book, required this.progress, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF10243A),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: const LinearGradient(colors: [Color(0xFF8D6E63), Color(0xFF263238)]),
          ),
          child: Icon(book.icon),
        ),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progress / 100),
            Text('%$progress'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class MiniBook extends StatelessWidget {
  final Book book;
  const MiniBook({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: const LinearGradient(colors: [Color(0xFF765548), Color(0xFF18212B)]),
              ),
              child: Icon(book.icon, size: 36),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class Stat extends StatelessWidget {
  final String a, b;
  const Stat(this.a, this.b, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(a, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        Text(b, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF20A9FF);
    final path = Path()
      ..moveTo(0, size.height * .78)
      ..lineTo(size.width * .6, size.height * .45)
      ..lineTo(size.width * .82, size.height * .5)
      ..lineTo(size.width, size.height * .15);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
