import 'dart:typed_data';

import 'package:omni_ledger/features/bill/domain/entities/bill.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdfGenerator {
  static const _primary = PdfColor.fromInt(0xFF006684);
  static const _secondary = PdfColor.fromInt(0xFF516066);
  static const _success = PdfColor.fromInt(0xFF2E7D32);
  static const _danger = PdfColor.fromInt(0xFFD32F2F);
  static const _primaryLight = PdfColor.fromInt(0xFFE0F4FF);
  static const _border = PdfColor.fromInt(0xFFD9E2E8);

  static Future<Uint8List> generate(Bill bill) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: _buildHeader(bill),
          ),
          pw.SizedBox(height: 24),
          _buildCustomer(bill),
          pw.SizedBox(height: 24),
          _buildItemsTable(bill),
          pw.SizedBox(height: 24),
          _buildSummary(bill),
          pw.SizedBox(height: 24),
          pw.Divider(color: _secondary),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              "Thank you for shopping with us!",
              style: pw.TextStyle(color: _secondary, fontSize: 10),
            ),
          ),
        ],
      ),
    );

    return await doc.save();
  }

  static pw.Widget _buildHeader(Bill bill) {
    final isPaid = bill.paymentStatus == "paid";

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "OMNI LEDGER",
                style: pw.TextStyle(
                  color: _primary,
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "Retail Invoice",
                style: pw.TextStyle(color: _secondary, fontSize: 11),
              ),
            ],
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              "Invoice #${bill.id}",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              _formatDate(bill.createdAt),
              style: pw.TextStyle(color: _secondary, fontSize: 11),
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: pw.BoxDecoration(
                color: isPaid ? _success : _danger,
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Text(
                bill.paymentStatus.toUpperCase(),
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCustomer(Bill bill) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _primaryLight,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "BILL TO",
            style: pw.TextStyle(
              color: _primary,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            bill.customerName.toUpperCase(),
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            bill.customerPhone,
            style: pw.TextStyle(color: _secondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(Bill bill) {
    final rows = <List<String>>[
      ["#", "Item", "Qty", "Amount"],
      for (var i = 0; i < bill.items.length; i++)
        [
          "${i + 1}",
          bill.items[i].itemName,
          "${bill.items[i].quantity}",
          "Rs. ${_formatAmount(bill.items[i].price)}",
        ],
    ];

    return pw.TableHelper.fromTextArray(
      headerCount: 1,
      data: rows,
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 11),
      headerStyle: pw.TextStyle(
        fontSize: 11,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: _primary),
      headerAlignment: pw.Alignment.centerLeft,
      cellPadding: const pw.EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(
          color: _border,
          width: 0.5,
        ),
      ),
    );
  }

  static pw.Widget _buildSummary(Bill bill) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: pw.BoxDecoration(
            color: _primaryLight,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "TOTAL",
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: _primary,
                ),
              ),
              pw.Text(
                "Rs. ${_formatAmount(bill.totalAmount)}",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  static String _formatDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return "$d-$m-$y  $h:$min";
  }
}