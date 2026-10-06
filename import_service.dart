import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:epubx/epubx.dart' as epubx;

/// Kullanıcıya gösterilecek Türkçe hata mesajı taşır.
class ImportException implements Exception {
  final String message;
  ImportException(this.message);
  @override
  String toString() => message;
}

class ImportResult {
  final String title;
  final String text;
  ImportResult(this.title, this.text);
}

class ImportService {
  static Future<ImportResult?> pickAndImport() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'epub'],
      withData: true,
    );
    if (result == null) return null;

    final picked = result.files.single;
    final extension = (picked.extension ?? '').toLowerCase();

    try {
      String text;
      switch (extension) {
        case 'pdf':
          text = await _extractPdf(picked);
          break;
        case 'epub':
          text = await _extractEpub(picked);
          break;
        case 'txt':
          text = await _extractTxt(picked);
          break;
        default:
          throw ImportException('Desteklenmeyen dosya türü: .$extension');
      }
      if (text.trim().isEmpty) {
        text = 'Dosyada metin bulunamadı.';
      }
      return ImportResult(picked.name, text);
    } on ImportException {
      rethrow;
    } catch (e) {
      throw ImportException('Dosya okunurken bir hata oluştu: $e');
    }
  }

  static Future<Uint8List> _bytesOf(PlatformFile file) async {
    if (file.bytes != null) return file.bytes!;
    if (file.path != null) return File(file.path!).readAsBytes();
    throw ImportException('Dosya verisine erişilemedi.');
  }

  static Future<String> _extractPdf(PlatformFile file) async {
    final bytes = await _bytesOf(file);
    final doc = PdfDocument(inputBytes: bytes);
    try {
      return PdfTextExtractor(doc).extractText();
    } finally {
      doc.dispose();
    }
  }

  static Future<String> _extractEpub(PlatformFile file) async {
    final bytes = await _bytesOf(file);
    final book = await epubx.EpubReader.readBook(bytes);
    final buffer = StringBuffer();
    final chapters = book.Chapters ?? const [];
    for (final chapter in chapters) {
      buffer.writeln(_stripHtml(chapter.HtmlContent ?? ''));
    }
    return buffer.toString();
  }

  static Future<String> _extractTxt(PlatformFile file) async {
    final bytes = await _bytesOf(file);
    return String.fromCharCodes(bytes);
  }

  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
