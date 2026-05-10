/// Constants used throughout the docx_creator package
class DocxConstants {
  // Page dimensions (in points)
  static const double defaultPageWidth = 612.0; // Letter width: 8.5 inches
  static const double defaultPageHeight = 792.0; // Letter height: 11 inches

  // Default margins (in twips - 1/20th of a point)
  static const int defaultMarginTop = 1440; // 1 inch
  static const int defaultMarginBottom = 1440; // 1 inch
  static const int defaultMarginLeft = 1440; // 1 inch
  static const int defaultMarginRight = 1440; // 1 inch

  // Font sizes
  static const double defaultFontSize = 12.0;

  // Line spacing
  static const int defaultLineSpacing = 240; // 12 pt

  // Table column widths
  static const int defaultTableWidth = 5000; // 100% in pct

  // Image dimensions
  static const int defaultImageWidth = 200;
  static const int defaultImageHeight = 100;

  // Conversion factors
  static const double pointsToTwips = 20.0; // 1 point = 20 twips
  static const double inchesToPoints = 72.0; // 1 inch = 72 points
  static const double pixelsToPoints = 0.75; // Approximate: 96 DPI / 72 DPI

  // Maximum image width (printable content width of A4/Letter with 1" margins)
  static const double maxImageWidth = 451.0; // ~451 pt

  // List indentation levels
  static const int listLevelIndent = 720; // 0.5 inch in twips

  // Table cell padding defaults
  static const int defaultTableCellPadding = 120; // 6 pt in twips

  // Header/footer spacing
  static const int headerFooterSpacing = 360; // 0.25 inch in twips

  // Heading styles spacing
  static const int heading1SpacingBefore = 300; // 15 pt
  static const int heading2SpacingBefore = 240; // 12 pt
  static const int heading3SpacingBefore = 200; // 10 pt
  static const int heading4SpacingBefore = 160; // 8 pt
  static const int heading5SpacingBefore = 120; // 6 pt
  static const int heading6SpacingBefore = 100; // 5 pt

  static const int headingSpacingAfter = 120; // 6 pt for all headings
}