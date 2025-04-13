import 'package:get/get.dart';
import 'package:kasir/app/modules/auth/login/bindings/binding_login.dart';
import 'package:kasir/app/modules/auth/login/views/loginpage.dart';
import 'package:kasir/app/modules/history/bindings/history_binding.dart';
import 'package:kasir/app/modules/history/views/history.dart';
import 'package:kasir/app/modules/home/bindings/binding_home.dart';
import 'package:kasir/app/modules/home/views/dashboard_admin.dart';
import 'package:kasir/app/modules/home/views/dashboard_kasir.dart';
import 'package:kasir/app/modules/product/bindings/product_binding.dart';
import 'package:kasir/app/modules/product/views/product.dart';
import 'package:kasir/app/modules/product/views/product_kasir.dart';
import 'package:kasir/app/modules/transaction/bindings/transaction_binding.dart';
import 'package:kasir/app/modules/transaction/views/checkout.dart';
import 'package:kasir/app/modules/transaction/views/konfirmasi.dart';
import 'package:kasir/app/modules/transaction/views/result.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialRoutes = Routes.initialRoute;
  static const dashboardadmin = Routes.dashboardadmin;
  static const dashboardkasir = Routes.dashboardkasir;
  static const product = Routes.product;
  static const user = Routes.user;
  static const productkasir = Routes.productkasir;
  static const checkout = Routes.checkout;
  static const konfirmasi = Routes.konfirmasi;
  static const result = Routes.result;
  static const history = Routes.history;

  static final routes = [
    GetPage(
      name: _Paths.initialRoute,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.dashboardadmin,
      page: () => DashboardAdmin(),
      binding: BindingHome(),
    ),
    GetPage(
        name: _Paths.dashboardkasir,
        page: () => DashboardKasir(),
        binding: BindingHome()),
    GetPage(
      name: _Paths.product,
      page: () => Product(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.user,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.productkasir,
      page: () => ProductKasir(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.checkout,
      page: () => Checkout(),
      binding: TransactionBinding(),
    ),
    GetPage(
        name: _Paths.konfirmasi,
        page: () => Konfirmasi(),
        binding: TransactionBinding()),
    GetPage(
      name: _Paths.result,
      page: () => Result(),
      bindings: [
        TransactionBinding(),
        ProductBinding(),
      ],
    ),
    GetPage(
      name: _Paths.history,
      page: () => History(),
      binding: HistoryBinding(),
    )
  ];
}
