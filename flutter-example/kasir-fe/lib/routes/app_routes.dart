part of 'app_pages.dart';

abstract class _Paths{
  static const initialRoute ='/';
  static const dashboardadmin = '/dashboard_admin';
  static const dashboardkasir = '/dashboard_kasir';
  static const product = '/product';
  static const user = '/user';
  static const productkasir = '/product_kasir';
  static const checkout = '/checkout';
  static const konfirmasi = '/konfirmasi';
  static const result = '/result';
  static const history = '/history';
}

abstract class Routes{
  Routes._();
  static const initialRoute = _Paths.initialRoute;
  static const dashboardadmin = _Paths.dashboardadmin;
  static const dashboardkasir = _Paths.dashboardkasir;
  static const product = _Paths.product;
  static const user = _Paths.user;
  static const productkasir = _Paths.productkasir;
  static const checkout = _Paths.checkout;
  static const konfirmasi = _Paths.konfirmasi;
  static const result = _Paths.result;
  static const history = _Paths.history;
}