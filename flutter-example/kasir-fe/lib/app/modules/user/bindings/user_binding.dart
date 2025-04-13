import 'package:get/get.dart';
import 'package:kasir/app/modules/user/controllers/user_controller.dart';

class ProductBinding extends Bindings{  
  @override

  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}