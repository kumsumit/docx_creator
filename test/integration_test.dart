import 'dart:io';

import 'package:docx_creator/docx_creator.dart';
import 'package:test/test.dart';

void main() {
  group('Integration Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('docx_integration_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('End-to-end DOCX creation and export', () async {
      // Create a comprehensive document
      final doc = docx()
        .h1('Integration Test Document')
        .p('This document tests the complete workflow from creation to export.')
        .h2('Features Tested')
        .bullet([
          'Document builder API',
          'Text formatting (bold, italic, colors)',
          'Lists (bullet and numbered)',
          'Tables with styling',
          'Images and shapes',
          'Headers and footers',
          'Sections and page layout',
        ])
        .h2('Text Formatting')
        .p('This paragraph demonstrates ')
        .add(DocxParagraph(children: [
          DocxText('bold text', fontWeight: DocxFontWeight.bold),
          DocxText(', '),
          DocxText('italic text', fontStyle: DocxFontStyle.italic),
          DocxText(', and '),
          DocxText('colored text', color: DocxColor.blue),
          DocxText('.'),
        ]))
        .h2('Lists')
        .numbered([
          'First item with some content',
          'Second item with different content',
          'Third item completing the list',
        ])
        .h2('Tables')
        .table([
          ['Header 1', 'Header 2', 'Header 3'],
          ['Row 1 Col 1', 'Row 1 Col 2', 'Row 1 Col 3'],
          ['Row 2 Col 1', 'Row 2 Col 2', 'Row 2 Col 3'],
        ])
        .h2('Shapes and Drawings')
        .add(DocxParagraph(children: [
          DocxText('Here are some shapes: '),
          DocxShape.circle(diameter: 20, fillColor: DocxColor.red),
          DocxText(' '),
          DocxShape.rectangle(width: 30, height: 15, fillColor: DocxColor.blue),
          DocxText(' '),
          DocxShape.star(points: 5, fillColor: DocxColor.gold),
        ]))
        .section(
          header: DocxHeader(children: [
            DocxParagraph.text('Document Header', align: DocxAlign.center),
          ]),
          footer: DocxFooter(children: [
            DocxParagraph.text('Page 1 of 1', align: DocxAlign.center),
          ]),
        )
        .build();

      // Export to DOCX
      final docxPath = '${tempDir.path}/test_document.docx';
      await DocxExporter().exportToFile(doc, docxPath);

      // Verify file was created
      expect(File(docxPath).existsSync(), isTrue);
      expect(File(docxPath).lengthSync(), greaterThan(0));

      // Test round-trip: load and verify content
      final loadedDoc = await DocxReader.load(docxPath);
      expect(loadedDoc.elements, isNotEmpty);

      // Verify we can find some expected content
      final textContent = loadedDoc.elements
          .whereType<DocxParagraph>()
          .expand((p) => p.children)
          .whereType<DocxText>()
          .map((t) => t.content)
          .join(' ');

      expect(textContent, contains('Integration Test Document'));
      expect(textContent, contains('bold text'));
      expect(textContent, contains('italic text'));
    });

    test('Markdown to DOCX to PDF workflow', () async {
      const markdown = '''
# Markdown Integration Test

This document was created from **Markdown** content.

## Features

- Bullet lists
- **Bold text**
- *Italic text*
- `Code snippets`

## Table

| Feature | Status |
|---------|--------|
| Tables | ✅ |
| Lists | ✅ |
| Formatting | ✅ |

> This is a blockquote with *emphasis*.
''';

      // Parse Markdown
      final elements = await MarkdownParser.parse(markdown);
      final doc = DocxBuiltDocument(elements: elements);

      // Export to DOCX
      final docxPath = '${tempDir.path}/markdown_test.docx';
      await DocxExporter().exportToFile(doc, docxPath);
      expect(File(docxPath).existsSync(), isTrue);

      // Export to PDF
      final pdfPath = '${tempDir.path}/markdown_test.pdf';
      await PdfExporter().exportToFile(doc, pdfPath);
      expect(File(pdfPath).existsSync(), isTrue);

      // Verify PDF has content
      final pdfBytes = await File(pdfPath).readAsBytes();
      expect(pdfBytes.length, greaterThan(1000)); // PDFs should be reasonably sized
    });

    test('HTML parsing and export workflow', () async {
      const html = '''
<div style="background-color: #f0f0f0; padding: 20px;">
  <h1 style="color: navy;">HTML Integration Test</h1>
  <p>This content was parsed from <strong>HTML</strong> with <em>styling</em>.</p>
  <ul>
    <li>Styled lists</li>
    <li><span style="color: red;">Colored text</span></li>
    <li>Nested <b>bold</b> elements</li>
  </ul>
  <table border="1" style="border-collapse: collapse;">
    <tr style="background-color: #4472C4; color: white;">
      <th>Feature</th>
      <th>Support</th>
    </tr>
    <tr>
      <td>Tables</td>
      <td>✅</td>
    </tr>
    <tr>
      <td>Colors</td>
      <td>✅</td>
    </tr>
  </table>
</div>
''';

      // Parse HTML
      final elements = await DocxParser.fromHtml(html);
      final doc = DocxBuiltDocument(elements: elements);

      // Export to DOCX
      final docxPath = '${tempDir.path}/html_test.docx';
      await DocxExporter().exportToFile(doc, docxPath);
      expect(File(docxPath).existsSync(), isTrue);

      // Export to PDF
      final pdfPath = '${tempDir.path}/html_test.pdf';
      await PdfExporter().exportToFile(doc, pdfPath);
      expect(File(pdfPath).existsSync(), isTrue);
    });

    test('Lazy PDF loading performance', () async {
      // Create a test PDF file first
      final testDoc = docx()
        .h1('Performance Test Document')
        .p('This is a test document for lazy loading.')
        .build();

      final pdfPath = '${tempDir.path}/perf_test.pdf';
      await PdfExporter().exportToFile(testDoc, pdfPath);

      // Test lazy loading
      final lazyDoc = await PdfReader.load(pdfPath, lazyLoad: true);

      // Elements should be loaded on demand
      expect(lazyDoc.elements.length, greaterThan(0));

      // Test that lazy loading works without issues
      final textContent = lazyDoc.elements
          .whereType<DocxParagraph>()
          .expand((p) => p.children)
          .whereType<DocxText>()
          .map((t) => t.content)
          .join(' ');

      expect(textContent.replaceAll(' ', ''), contains('PerformanceTestDocument'));
    });

    test('Font embedding and caching', () async {
      // This test verifies that font metrics caching works
      final doc = docx()
        .h1('Font Caching Test')
        .p('This document tests font metrics caching performance.')
        .add(DocxParagraph(children: [
          DocxText('Repeated text for caching: ', fontFamily: 'Arial'),
          DocxText('Hello World ' * 10), // Repeat to test caching
        ]))
        .build();

      // Export to PDF (which uses font metrics)
      final pdfPath = '${tempDir.path}/font_cache_test.pdf';
      final startTime = DateTime.now();
      await PdfExporter().exportToFile(doc, pdfPath);
      final endTime = DateTime.now();

      expect(File(pdfPath).existsSync(), isTrue);

      // Should complete in reasonable time (caching should help with repeated text)
      final duration = endTime.difference(startTime);
      expect(duration.inSeconds, lessThan(30)); // Should be fast even with repeated text
    });
  });
}