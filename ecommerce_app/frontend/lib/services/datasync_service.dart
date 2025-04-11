import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/services/database_helper.dart';

class DataSyncService {
  // Phương thức này sẽ kiểm tra kết nối mạng và đồng bộ dữ liệu
  static Future<void> syncData() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("Có kết nối Internet");

      // Nếu có kết nối internet, lấy dữ liệu từ API và lưu vào SQLite
      try {
        List<Map<String, dynamic>> products = await ApiService.getProducts();

        // Lưu dữ liệu vào SQLite
        await DatabaseHelper.instance.insertProducts(products);
        print("Dữ liệu đã được lưu vào SQLite");
      } catch (e) {
        print("Lỗi khi lấy dữ liệu từ API: $e");
      }
    } else {
      print("Không có kết nối Internet");

      // Khi không có kết nối, lấy dữ liệu từ SQLite
      _loadDataFromSQLite();
    }
  }

  // Lấy dữ liệu từ SQLite khi không có kết nối
  static Future<void> _loadDataFromSQLite() async {
    try {
      List<Map<String, dynamic>> products =
          await DatabaseHelper.instance.getProducts();
      if (products.isEmpty) {
        print("Không có dữ liệu trong SQLite");
      } else {
        print("Dữ liệu được lấy từ SQLite: $products");
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu từ SQLite: $e");
    }
  }
}
