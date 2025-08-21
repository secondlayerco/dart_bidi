import 'package:bidi/bidi.dart' as bidi;
import 'package:test/test.dart';

void main() {
  test('Paragraph embedding level non-mixed', () {
    expect(
        bidi.BidiString.fromLogical('Hello world!')
            .paragraphs
            .first
            .embeddingLevel,
        0);
    expect(
        bidi.BidiString.fromLogical('مرحبا بالعالم')
            .paragraphs
            .first
            .embeddingLevel,
        1);
    expect(
        bidi.BidiString.fromLogical('שלום עולם')
            .paragraphs
            .first
            .embeddingLevel,
        1);
  });

  test('Paragraph embedding level mixed, not nested', () {
    expect(
        bidi.BidiString.fromLogical('Hello مرحبا بالعالم')
            .paragraphs
            .first
            .embeddingLevel,
        0);
    expect(
        bidi.BidiString.fromLogical('你好 שלום עולם')
            .paragraphs
            .first
            .embeddingLevel,
        0);
    expect(
        bidi.BidiString.fromLogical('مرحبا بالعالم 你好')
            .paragraphs
            .first
            .embeddingLevel,
        1);
    expect(
        bidi.BidiString.fromLogical('שלום עולם Hello')
            .paragraphs
            .first
            .embeddingLevel,
        1);
  });

  test('Paragraph embedding level nested', () {
    expect(
        bidi.BidiString.fromLogical('Hello مرحبا بالعالم 你好')
            .paragraphs
            .first
            .embeddingLevel,
        0);
    expect(
        bidi.BidiString.fromLogical('שלום 你好 مرحبا بالعالم')
            .paragraphs
            .first
            .embeddingLevel,
        1);
  });

  test('Character embedding levels non-mixed', () {
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

  test('Character embedding mixed, not nested', () {
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

  test('Character embedding nested', () {
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
