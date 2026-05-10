import 'dart:typed_data';

import 'package:docx_creator/src/reader/pdf_reader/pdf_reader.dart';
import 'package:test/test.dart';

void main() {
  group('PdfReader strict mode', () {
    final malformedPdf = Uint8List.fromList(
      '''
%PDF-1.4
1 0 obj
<< /Type /Catalog >>
endobj
%%EOF
'''
          .codeUnits,
    );

    test('keeps tolerant warning behavior by default', () async {
      final doc = await PdfReader.loadFromBytes(malformedPdf);

      expect(doc.warnings, isNotEmpty);
      expect(doc.warnings.first, contains('Parse error'));
    });

    test('throws parse exceptions when strict is enabled', () async {
      expect(
        () => PdfReader.loadFromBytes(malformedPdf, strict: true),
        throwsA(isA<PdfParseException>()),
      );
    });
  });
}
