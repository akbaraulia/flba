import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HistoryController extends GetxController {
  final box = GetStorage();
  var groupedPayments = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPayments();
    super.onInit();
  }

  Future<void> fetchPayments() async {
    final token = box.read('token');
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('http://192.168.158.106:8000/api/payments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        groupedPayments.value = data;
      } else {
        Get.snackbar('Error', 'Gagal mengambil riwayat transaksi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generatePDF(Map group) async {
    final pdf = pw.Document();

    final items = group['items'] as List;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Riwayat Transaksi', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('Tanggal: ${group['created_at']}'),
            pw.Text('Total: Rp ${group['total_price']}'),
            pw.Text('Bayar: Rp ${group['pay']}'),
            pw.Text('Kembali: Rp ${group['change']}'),
            pw.SizedBox(height: 16),
            pw.Text('Produk:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: items.map<pw.Widget>((p) {
                final product = p['product'];
                final productName = product != null
                    ? product['name_product']
                    : '[Produk tidak ditemukan]';
                final qty = p['qty'] ?? 0;
                return pw.Text('$productName x$qty');
              }).toList(),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }


  
}
