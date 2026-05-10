import 'package:docx_creator/src/editor/element_tree.dart';
import 'package:docx_creator/src/exporters/pdf/pdf_content_builder.dart';
import 'package:test/test.dart';

void main() {
  group('PDF color robustness', () {
    test('content builder ignores invalid hex colors', () {
      final builder = PdfContentBuilder();

      expect(() => builder.setFillColorHex('GGGGGG'), returnsNormally);
      expect(() => builder.setStrokeColorHex('#12ZZ56'), returnsNormally);
      expect(builder.content, isEmpty);
    });

    test('editor elements render invalid hex colors with black fallback', () {
      final text = TextElement(
        x: 10,
        y: 10,
        content: 'Text',
        colorHex: 'ZZZZZZ',
      );
      final shape = ShapeElement(
        x: 10,
        y: 10,
        width: 20,
        height: 20,
        fillHex: 'GGGGGG',
        strokeHex: '#XYZXYZ',
      );

      expect(() => text.render(), returnsNormally);
      expect(() => shape.render(), returnsNormally);
      expect(text.render(), contains('0 0 0 rg'));
      expect(shape.render(), contains('0 0 0 rg'));
      expect(shape.render(), contains('0 0 0 RG'));
    });
  });
}
