import 'package:hive/hive.dart';
import 'package:ecommerce_app/models/product.dart';

class HiveBoxes {
  static const String productBoxName = 'products';

  // Mở hộp sản phẩm
  static Future<Box<Product>> openProductBox() async {
    return await Hive.openBox<Product>(productBoxName);
  }

  // Lưu một sản phẩm vào Hive
  static Future<void> saveProduct(Product product) async {
    var box = await openProductBox();
    await box.put(product.id, product);
  }

  // Lấy danh sách sản phẩm từ Hive
  static Future<List<Product>> getProducts() async {
    var box = await openProductBox();
    return box.values.toList();
  }

  // Xóa tất cả sản phẩm trong hộp
  static Future<void> clearProducts() async {
    var box = await openProductBox();
    await box.clear();
  }
}
