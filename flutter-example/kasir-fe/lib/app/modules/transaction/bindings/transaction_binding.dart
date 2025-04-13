import 'package:get/get.dart';
import 'package:kasir/app/modules/product/controllers/product_controller.dart';
import 'package:kasir/app/modules/transaction/controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override

  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
