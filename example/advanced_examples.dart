import 'package:docx_creator/docx_creator.dart';

/// Advanced examples showing complex document generation features
void main() async {
  await generateReport();
  await generateInvoice();
  await generateNewsletter();
}

/// Generate a comprehensive business report
Future<void> generateReport() async {
  final report = docx()
    // Title page
    .h1('Annual Business Report')
    .p('Fiscal Year 2024', align: DocxAlign.center)
    .p('Prepared by: Analytics Department', align: DocxAlign.center)
    .pageBreak()

    // Executive Summary
    .h1('Executive Summary')
    .p('This report provides a comprehensive overview of our company\'s performance over the past fiscal year.')
    .quote('Key highlights include 25% revenue growth and successful market expansion.')
    .pageBreak()

    // Financial Overview with table
    .h1('Financial Overview')
    .table([
      ['Metric', 'Q1', 'Q2', 'Q3', 'Q4', 'Total'],
      ['Revenue (\$M)', '45.2', '52.1', '48.7', '61.3', '207.3'],
      ['Expenses (\$M)', '32.1', '35.8', '33.2', '38.9', '140.0'],
      ['Profit (\$M)', '13.1', '16.3', '15.5', '22.4', '67.3'],
      ['Growth %', '12%', '18%', '15%', '28%', '25%'],
    ], hasHeader: true)
    .p('Total revenue increased by 25% compared to the previous year.', align: DocxAlign.center)
    .pageBreak()

    // Charts section (using shapes as placeholders)
    .h1('Performance Charts')
    .p('The following charts illustrate our growth trajectory:')
    .add(DocxShapeBlock.rectangle(
      width: 400,
      height: 200,
      fillColor: DocxColor.cyan,
      text: 'Revenue Growth Chart\n(Placeholder)',
      align: DocxAlign.center,
    ))
    .pageBreak()

    // Recommendations
    .h1('Recommendations')
    .numbered([
      'Continue investment in R&D to maintain competitive advantage',
      'Expand market presence in emerging regions',
      'Optimize operational efficiency to reduce costs',
      'Strengthen customer relationship management',
    ])

    .build();

  await DocxExporter().exportToFile(report, 'annual_report.docx');
  print('Generated annual report');
}

/// Generate a professional invoice
Future<void> generateInvoice() async {
  final invoice = docx()
    // Header
    .h1('INVOICE')
    .p('Invoice #: INV-2024-001', align: DocxAlign.right)
    .p('Date: ${DateTime.now().toString().split(' ')[0]}', align: DocxAlign.right)
    .p('Due Date: ${DateTime.now().add(Duration(days: 30)).toString().split(' ')[0]}', align: DocxAlign.right)
    .hr()

    // Billing information
    .table([
      ['Bill To:', 'Ship To:'],
      ['Acme Corporation\n123 Business St\nBusiness City, BC 12345', 'Acme Corporation\n123 Business St\nBusiness City, BC 12345'],
    ], hasHeader: false)
    .hr()

    // Items table
    .table([
      ['Item', 'Description', 'Qty', 'Unit Price', 'Total'],
      ['SV001', 'Software License - Annual', '1', '\$2,500.00', '\$2,500.00'],
      ['SUP001', 'Premium Support - 1 Year', '1', '\$750.00', '\$750.00'],
      ['TRN001', 'Training Session - 2 Days', '1', '\$1,200.00', '\$1,200.00'],
      ['', '', '', 'Subtotal:', '\$4,450.00'],
      ['', '', '', 'Tax (8.5%):', '\$378.25'],
      ['', '', '', 'Total:', '\$4,828.25'],
    ], hasHeader: true)
    .hr()

    // Payment terms
    .p('Payment Terms: Net 30 days')
    .p('Please make payment to:')
    .p('Account Name: Our Company Inc.')
    .p('Account Number: 123456789')
    .p('Routing Number: 021000021')
    .p('Bank: First National Bank')

    .build();

  await DocxExporter().exportToFile(invoice, 'invoice.docx');
  print('Generated invoice');
}

/// Generate a newsletter with rich formatting
Future<void> generateNewsletter() async {
  final newsletter = docx()
    // Header with logo placeholder
    .add(DocxShapeBlock.rectangle(
      width: 200,
      height: 60,
      fillColor: DocxColor.blue,
      text: 'Company Logo',
      align: DocxAlign.center,
    ))
    .add(DocxParagraph.text('Monthly Newsletter - May 2024', align: DocxAlign.center))
    .hr()

    // Featured article
    .h1('🚀 New Product Launch')
    .p('We\'re excited to announce the launch of our revolutionary new product that will transform the industry.')
    .add(DocxParagraph(children: [
      DocxText('Key features include:'),
      DocxShape.circle(diameter: 20, fillColor: DocxColor.green),
      DocxText(' Advanced AI capabilities'),
      DocxShape.circle(diameter: 20, fillColor: DocxColor.green),
      DocxText(' Seamless integration'),
      DocxShape.circle(diameter: 20, fillColor: DocxColor.green),
      DocxText(' Enterprise-grade security'),
    ]))

    // Image placeholder
    .add(DocxShapeBlock.rectangle(
      width: 300,
      height: 150,
      fillColor: DocxColor.lightGray,
      text: 'Product Image',
      align: DocxAlign.center,
    ))

    .pageBreak()

    // Company news
    .h1('🏢 Company Updates')
    .h2('Q1 Results Exceed Expectations')
    .p('Our Q1 performance has exceeded all projections, with revenue growth of 35% year-over-year.')

    .h2('New Office Opening')
    .p('We\'ve expanded our presence with a new office in San Francisco, bringing our total locations to 12 worldwide.')

    .h2('Employee Spotlight')
    .p('Congratulations to Sarah Johnson for being named Employee of the Month for her outstanding contributions to the mobile app project.')

    .pageBreak()

    // Upcoming events
    .h1('📅 Upcoming Events')
    .bullet([
      'Tech Conference 2024 - June 15-17, Las Vegas',
      'Annual Company Picnic - June 22, Central Park',
      'Product Training Workshop - June 28, Online',
    ])

    // Footer
    .hr()
    .p('Stay connected with us!', align: DocxAlign.center)
    .p('Website: www.company.com | Email: newsletter@company.com', align: DocxAlign.center)
    .p('© 2024 Our Company Inc. All rights reserved.', align: DocxAlign.center)

    .build();

  await DocxExporter().exportToFile(newsletter, 'newsletter.docx');
  print('Generated newsletter');
}