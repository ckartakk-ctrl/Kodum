import 'dart:async';
import 'package:flutter/material.dart';
import 'storage_service.dart';

/// Tüm hız seçenekleri (100-1000 WPM) herkese açıktır.
class ReaderPage extends StatefulWidget {
  final String? text;
  final String? title;

  /// İlerlemeyi kaydetmek için benzersiz anahtar (kitap adı).
  /// Alt menüdeki genel okuyucuda null'dır.
  final String? bookKey;
  const ReaderPage({super.key, this.text, this.title, this.bookKey});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  static const _fallbackText =
      'Bugün hava çok güzel olduğu için dışarı çıkmaya karar verdik. '
      'FocusRead ile okuma hızını geliştirebilir, dikkatini tek bir '
      'noktada toplayabilirsin.';

  int wpm = 250;
  int index = 0;
  Timer? timer;
  List<String> words = [];
  bool playing = false;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    final raw = widget.text ?? _fallbackText;
    words = raw.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) {
      words = _fallbackText.split(RegExp(r'\s+'));
    }
    _loadWpm();
  }

  Future<void> _loadWpm() async {
    final saved = await StorageService.loadWpm();
    if (!mounted) return;
    setState(() {
      wpm = saved.clamp(100, 1000);
      ready = true;
    });
  }

  int get _percent => (((index + 1) / words.length) * 100).round();

  void _persistProgress() {
    final key = widget.bookKey;
    if (key == null) return;
    StorageService.saveProgress(key, _percent);
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: (60000 / wpm).round()), (_) {
      if (index >= words.length - 1) {
        timer?.cancel();
        setState(() => playing = false);
        return;
      }
      setState(() => index++);
      _persistProgress();
    });
  }

  void toggle() {
    if (playing) {
      timer?.cancel();
      setState(() => playing = false);
      return;
    }
    setState(() => playing = true);
    _startTimer();
  }

  void _setWpm(int value) {
    setState(() => wpm = value);
    StorageService.saveWpm(value);
    if (playing) _startTimer(); // hız değişince oynatma anında yeni hıza geçer
  }

  void _close() {
    _persistProgress();
    Navigator.pop(context, widget.bookKey != null ? _percent : null);
  }

  @override
  void dispose() {
    timer?.cancel();
    _persistProgress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(
        backgroundColor: Color(0xFF020B16),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _close();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF020B16),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(onPressed: _close, icon: const Icon(Icons.arrow_back)),
                    Expanded(
                      child: Text(widget.title ?? 'FocusRead', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text('$_percent%'),
                  ],
                ),
              ),
              LinearProgressIndicator(value: (index + 1) / words.length, minHeight: 3),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 120),
                    child: Text(
                      words[index],
                      key: ValueKey(index),
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Text('${index + 1} / ${words.length} kelime', style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() => index = index > 0 ? index - 1 : 0),
                    icon: const Icon(Icons.chevron_left, size: 32),
                  ),
                  const SizedBox(width: 15),
                  FloatingActionButton.large(
                    onPressed: toggle,
                    child: Icon(playing ? Icons.pause : Icons.play_arrow, size: 34),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: () => setState(() => index = index < words.length - 1 ? index + 1 : index),
                    icon: const Icon(Icons.chevron_right, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Hız: $wpm WPM', style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: wpm.toDouble(),
                min: 100,
                max: 1000,
                divisions: 18,
                label: '$wpm WPM',
                onChanged: (v) => _setWpm(v.round()),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
