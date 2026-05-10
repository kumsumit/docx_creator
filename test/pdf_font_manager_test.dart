import 'package:docx_creator/src/exporters/pdf/pdf_font_manager.dart';
import 'package:test/test.dart';

void main() {
  group('PdfFontManager', () {
    test(
      'escapes standard PDF strings without dropping unsupported Unicode',
      () {
        final manager = PdfFontManager();

        expect(manager.escapeText(r'A (B) \ C'), r'A \(B\) \\ C');
        expect(manager.escapeText('A😀B'), equals('A?B'));
        expect(manager.escapeText('A\nB\tC'), equals('A B C'));
      },
    );

    test('measures surrogate-pair characters as one fallback code point', () {
      final manager = PdfFontManager();

      final width = manager.measureText('😀', 12);

      expect(width, equals(PdfFontManager.avgCharWidth * 12));
    });
  });
}
