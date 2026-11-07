import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final response = await _supabase
          .from('transactions') // Sesuaikan dengan nama tabel di Supabase kamu
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _transactions = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data laporan: $e')),
        );
      }
    }
  }

  // Mengembalikan Uint8List (pdf.save()) sesuai kebutuhan PdfPreview
  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    // Hitung Ringkasan
    double totalPemasukan = 0;
    double totalPengeluaran = 0;

    for (var item in _transactions) {
      final amount = (item['amount'] ?? 0).toDouble();
      final type = item['type'] ?? 'pemasukan';
      if (type == 'pemasukan' || type == 'in' || type == 'deposit') {
        totalPemasukan += amount;
      } else {
        totalPengeluaran += amount;
      }
    }

    final totalSaldo = totalPemasukan - totalPengeluaran;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'LAPORAN TABUNGAN',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      DateTime.now().toString().split(' ')[0],
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.teal),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('Total Pemasukan',
                            style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Rp ${totalPemasukan.toStringAsFixed(0)}',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Total Pengeluaran',
                            style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Rp ${totalPengeluaran.toStringAsFixed(0)}',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Saldo Sisa',
                            style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Rp ${totalSaldo.toStringAsFixed(0)}',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Rincian Transaksi:',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['No', 'Keterangan', 'Tipe', 'Jumlah'],
                data: List<List<dynamic>>.generate(_transactions.length, (index) {
                  final item = _transactions[index];
                  return [
                    (index + 1).toString(),
                    item['title'] ?? item['description'] ?? 'Tanpa Keterangan',
                    (item['type'] ?? 'Pemasukan').toString().toUpperCase(),
                    'Rp ${(item['amount'] ?? 0).toString()}',
                  ];
                }),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.teal,
                ),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300, width: .5),
                  ),
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellAlignments: {
                  0: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerRight,
                },
              ),
            ],
          );
        },
      ),
    );

    // Mengubah dokumen PDF menjadi byte Uint8List
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cetak Laporan'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PdfPreview(
              build: (format) => _generatePdf(format),
              pdfFileName:
                  'Laporan_Tabungan_${DateTime.now().millisecondsSinceEpoch}.pdf',
            ),
    );
  }
}