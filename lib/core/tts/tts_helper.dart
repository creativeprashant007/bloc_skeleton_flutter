// import 'package:flutter_tts/flutter_tts.dart';

// enum TtsLocale { en, pt }

// class TtsHelper {
//   TtsHelper._internal();

//   static final TtsHelper instance = TtsHelper._internal();

//   late final FlutterTts _tts;
//   bool _initialized = false;

//   // You can switch between pt-PT / pt-BR anytime
//   String portugueseLocale = "pt-PT";
//   String englishLocale = "en-US";

//   Future<void> init() async {
//     if (_initialized) return;

//     _tts = FlutterTts();

//     // common tuning (adjust if you want)
//     await _tts.setSpeechRate(0.45);
//     await _tts.setPitch(1.0);
//     await _tts.setVolume(1.0);

//     // Makes await speak completion possible
//     await _tts.awaitSpeakCompletion(true);

//     _initialized = true;
//   }

//   /// Plays text with a simple locale input: TtsLocale.pt or TtsLocale.en
//   Future<void> speak({
//     required String text,
//     required TtsLocale locale,
//   }) async {
//     await init();

//     // Always stop current speech first to avoid overlap
//     await _tts.stop();

//     final lang = switch (locale) {
//       TtsLocale.en => englishLocale,
//       TtsLocale.pt => portugueseLocale,
//     };

//     await _tts.setLanguage(lang);
//     await _tts.speak(text);
//   }

//   Future<void> stop() async {
//     if (!_initialized) return;
//     await _tts.stop();
//   }

//   Future<void> dispose() async {
//     if (!_initialized) return;
//     await _tts.stop();
//     // flutter_tts does not require explicit dispose in most cases,
//     // but we keep this for consistency.
//   }
// }
