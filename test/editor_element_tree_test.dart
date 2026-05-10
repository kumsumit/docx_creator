import 'package:docx_creator/docx_creator.dart';
import 'package:test/test.dart';

void main() {
  group('ElementTree', () {
    test('generates unique element IDs for rapid construction', () {
      final ids = List.generate(
        100,
        (_) => TextElement(x: 0, y: 0, content: 'x').id,
      );

      expect(ids.toSet(), hasLength(ids.length));
    });

    test('hitTest returns the topmost element by z-index', () {
      final tree = ElementTree();
      final bottom = ShapeElement(
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        zIndex: 1,
      );
      final top = ShapeElement(x: 0, y: 0, width: 100, height: 100, zIndex: 2);

      tree.addElement(bottom);
      tree.addElement(top);

      expect(tree.hitTest(50, 50), same(top));
    });

    test('copyWith preserves and updates image-specific fields', () {
      final image = ImageElement(
        x: 1,
        y: 2,
        width: 3,
        height: 4,
        bytes: [1, 2, 3],
        extension: 'png',
        xObjectName: '/Im1',
      );

      final copied =
          image.copyWith(width: 10, extension: 'jpg', xObjectName: '/Im2')
              as ImageElement;

      expect(copied.id, equals(image.id));
      expect(copied.bytes, equals([1, 2, 3]));
      expect(copied.width, equals(10));
      expect(copied.extension, equals('jpg'));
      expect(copied.xObjectName, equals('/Im2'));
    });

    test('copyWith preserves and updates shape-specific fields', () {
      final shape = ShapeElement(
        x: 1,
        y: 2,
        width: 3,
        height: 4,
        preset: 'rect',
        fillHex: 'FF0000',
        strokeHex: '000000',
      );

      final copied =
          shape.copyWith(preset: 'ellipse', fillHex: '00FF00', strokeWidth: 2)
              as ShapeElement;

      expect(copied.id, equals(shape.id));
      expect(copied.preset, equals('ellipse'));
      expect(copied.fillHex, equals('00FF00'));
      expect(copied.strokeHex, equals('000000'));
      expect(copied.strokeWidth, equals(2));
    });
  });
}
