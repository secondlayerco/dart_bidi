import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  test('Emebdding levels non-mixed', () {
    final data = [
      MapEntry('Hello world!', List.filled(12, 0)),
      MapEntry('你好，世界', List.filled(5, 0)),
      MapEntry('مرحبا بالعالم', List.filled(13, 1)),
      MapEntry('שלום עולם', List.filled(9, 1)),
    ];
    for (final entry in data) {
      final levels = bidi.BidiString.fromLogical(entry.key)
          .paragraphs
          .first
          .embeddingLevels;
      expect(levels.length, entry.value.length);
      expect(levels, entry.value);
    }
  });

  test('Emebdding levels mixed, not nested', () {
    final data = [
      MapEntry('Hello مرحبا بالعالم', List.filled(6, 0) + List.filled(13, 1)),
      MapEntry('你好 שלום עולם', List.filled(3, 0) + List.filled(9, 1)),
      MapEntry('مرحبا بالعالم 你好', List.filled(14, 1) + List.filled(2, 2)),
      MapEntry('שלום עולם Hello', List.filled(10, 1) + List.filled(5, 2))
    ];
    for (final entry in data) {
      final levels = bidi.BidiString.fromLogical(entry.key)
          .paragraphs
          .first
          .embeddingLevels;
      expect(levels.length, entry.value.length);
      expect(levels, entry.value);
    }
  });

  test('Emebdding levels nested', () {
    final data = [
      MapEntry('Hello مرحبا بالعالم 你好',
          List.filled(6, 0) + List.filled(13, 1) + List.filled(3, 0)),
      MapEntry('שלום 你好 مرحبا بالعالم',
          List.filled(5, 1) + List.filled(2, 2) + List.filled(14, 1)),
    ];
    for (final entry in data) {
      final levels = bidi.BidiString.fromLogical(entry.key)
          .paragraphs
          .first
          .embeddingLevels;
      expect(levels.length, entry.value.length);
      expect(levels, entry.value);
    }
  });
}
