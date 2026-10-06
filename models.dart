import 'package:flutter/material.dart';

/// Katalog kaydı. Okuma ilerlemesi burada değil, SharedPreferences'ta tutulur.
class Book {
  final String title;
  final String author;
  final IconData icon;
  const Book(this.title, this.author, this.icon);
}
