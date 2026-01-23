import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<pw.Document> generateInvoicePdf({
    required Map<String, dynamic> invoice,
    required Map<String, dynamic>? business,
    required Map<String, dynamic>? client,
  }) async {
    final pdf = pw.Document();
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM dd, yyyy');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(business, dateFormat, invoice),
              pw.SizedBox(height: 30),

              // Invoice Details and Client Info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildInvoiceDetails(invoice, dateFormat),
                  _buildClientInfo(client),
                ],
              ),
              pw.SizedBox(height: 30),

              // Line Items Table
              _buildLineItemsTable(invoice, currencyFormat),
              pw.SizedBox(height: 20),

              // Totals
              _buildTotals(invoice, currencyFormat),
              pw.Spacer(),

              // Footer
              _buildFooter(invoice),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(
    Map<String, dynamic>? business,
    DateFormat dateFormat,
    Map<String, dynamic> invoice,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              business?['business_name'] ?? 'Your Business',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            if (business?['email'] != null)
              pw.Text(business!['email'], style: const pw.TextStyle(fontSize: 10)),
            if (business?['phone'] != null)
              pw.Text(business!['phone'], style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 32,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue700,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              '#${invoice['invoice_number']}',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildInvoiceDetails(
    Map<String, dynamic> invoice,
    DateFormat dateFormat,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Invoice Details',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _buildDetailRow('Invoice Date:', dateFormat.format(DateTime.parse(invoice['invoice_date']))),
        _buildDetailRow('Due Date:', dateFormat.format(DateTime.parse(invoice['due_date']))),
        _buildDetailRow('Status:', invoice['status'].toString().toUpperCase()),
      ],
    );
  }

  static pw.Widget _buildClientInfo(Map<String, dynamic>? client) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Bill To',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          client?['company_name'] ?? client?['first_name'] ?? 'Client',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (client?['email'] != null)
          pw.Text(client!['email'], style: const pw.TextStyle(fontSize: 10)),
        if (client?['phone'] != null)
          pw.Text(client!['phone'], style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLineItemsTable(
    Map<String, dynamic> invoice,
    NumberFormat currencyFormat,
  ) {
    final items = invoice['items'] as List? ?? [];

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Description', isHeader: true),
            _buildTableCell('Qty', isHeader: true, align: pw.TextAlign.center),
            _buildTableCell('Price', isHeader: true, align: pw.TextAlign.right),
            _buildTableCell('Amount', isHeader: true, align: pw.TextAlign.right),
          ],
        ),
        // Items
        ...items.map((item) {
          final qty = item['quantity'] ?? 1.0;
          final price = item['unit_price'] ?? 0.0;
          final amount = qty * price;

          return pw.TableRow(
            children: [
              _buildTableCell(item['description'] ?? ''),
              _buildTableCell('$qty', align: pw.TextAlign.center),
              _buildTableCell(currencyFormat.format(price), align: pw.TextAlign.right),
              _buildTableCell(currencyFormat.format(amount), align: pw.TextAlign.right),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }

  static pw.Widget _buildTotals(
    Map<String, dynamic> invoice,
    NumberFormat currencyFormat,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 250,
          child: pw.Column(
            children: [
              _buildTotalRow('Subtotal:', currencyFormat.format(invoice['subtotal'] ?? 0)),
              _buildTotalRow('Tax:', currencyFormat.format(invoice['tax_amount'] ?? 0)),
              pw.Divider(thickness: 2),
              _buildTotalRow(
                'Total:',
                currencyFormat.format(invoice['total_amount'] ?? 0),
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 11,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isTotal ? 16 : 11,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(Map<String, dynamic> invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (invoice['notes'] != null && invoice['notes'].toString().isNotEmpty) ...[
          pw.Text(
            'Notes:',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            invoice['notes'],
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.Center(
          child: pw.Text(
            'Thank you for your business!',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ),
      ],
    );
  }

  // Preview PDF
  static Future<void> previewPdf(pw.Document pdf) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // Share PDF
  static Future<void> sharePdf(pw.Document pdf, String fileName) async {
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: '$fileName.pdf',
    );
  }

  // Save PDF to device
  static Future<File> savePdf(pw.Document pdf, String fileName) async {
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
