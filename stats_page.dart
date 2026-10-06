import 'package:flutter/material.dart';
import 'widgets.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'İstatistikler',
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: const Color(0xFF0D2238), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Stat('280', 'WPM'), Stat('184.320', 'Kelime'), Stat('12s 36dk', 'Okuma')],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Hız Gelişimi', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Container(
            height: 180,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: const Color(0xFF0D2238), borderRadius: BorderRadius.circular(20)),
            child: CustomPaint(painter: ChartPainter()),
          ),
          const SizedBox(height: 24),
          const Text('Hedefler', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const ListTile(
            leading: Icon(Icons.flag),
            title: Text('Haftalık hedef'),
            subtitle: Text('18.420 / 50.000 kelime'),
            trailing: Text('37%'),
          ),
        ],
      ),
    );
  }
}
