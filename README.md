# FocusRead

Tüm özellikler herkese açıktır (Premium/abonelik yoktur): PDF/EPUB/TXT içe aktarma,
100–1000 WPM hız aralığı, istatistikler, kalıcı ilerleme.

## APK alma
**GitHub Actions (kurulumsuz):** Bu klasörün içeriğini bir GitHub deposuna yükle →
Actions sekmesi → "Build APK" çalışsın → altta `focusread-apk` dosyasını indir.

**Kendi bilgisayarında:**
```bash
flutter create . --platforms=android
flutter pub get
flutter build apk --release
```
APK: `build/app/outputs/flutter-apk/app-release.apk`

Not: Kod burada derlenemedi; ilk derlemede küçük bir hata çıkarsa
(özellikle `epubx` API'si) hata mesajını paylaşırsan düzeltirim.
