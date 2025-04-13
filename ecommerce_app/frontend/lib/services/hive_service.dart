import 'package:hive/hive.dart';

class HiveService {
  static Box? _productBox;
  static Box? _reviewBox;
  static Box? _userInfoBox;

  // Mở hộp Hive
  static Future<void> _openBoxes() async {
    if (_productBox == null) {
      _productBox = await Hive.openBox('products');
    }
    if (_reviewBox == null) {
      _reviewBox = await Hive.openBox('reviews');
    }
    if (_userInfoBox == null) {
      _userInfoBox = await Hive.openBox('user_info');
    }
  }

  // Lưu sản phẩm vào Hive
  static Future<void> saveProducts(List<dynamic> products) async {
    await _openBoxes();
    for (var product in products) {
      await _productBox?.put(product['_id'], product);
    }
  }

  // Lấy sản phẩm từ Hive
  static Future<List<Map<String, dynamic>>> getProducts() async {
    await _openBoxes();
    return _productBox?.values.cast<Map<String, dynamic>>().toList() ?? [];
  }

  // Lấy chi tiết sản phẩm từ Hive
  static Future<Map<String, dynamic>?> getProductDetailFromHive(
    String productId,
  ) async {
    await _openBoxes();
    var product = _productBox?.get(productId);
    return product != null ? product as Map<String, dynamic> : null;
  }

  // Thêm sản phẩm vào Hive
  static Future<void> addProduct(Map<String, dynamic> product) async {
    await _openBoxes();
    await _productBox?.put(product['_id'], product);
  }

  // Cập nhật sản phẩm trong Hive
  static Future<void> updateProduct(
    String productId,
    Map<String, dynamic> updatedProduct,
  ) async {
    await _openBoxes();
    await _productBox?.put(productId, updatedProduct);
  }

  // Xóa sản phẩm từ Hive
  static Future<void> deleteProduct(String productId) async {
    await _openBoxes();
    await _productBox?.delete(productId);
  }

  // Lưu đánh giá vào Hive
  static Future<void> saveReview(
    String productId,
    Map<String, dynamic> review,
  ) async {
    await _openBoxes();
    await _reviewBox?.put(productId, review);
  }

  // Lưu tất cả bình luận của sản phẩm vào Hive
  static Future<void> saveReviews(
    String productId,
    List<dynamic> reviews,
  ) async {
    await _openBoxes();
    await _reviewBox?.put(productId, reviews);
  }

  // Lấy đánh giá của sản phẩm từ Hive
  static Future<List<Map<String, dynamic>>> getReviewsFromHive(
    String productId,
  ) async {
    await _openBoxes();
    var reviews = _reviewBox?.get(productId) as List<dynamic>?;
    return reviews?.map((review) => review as Map<String, dynamic>).toList() ??
        [];
  }

  // Lưu thông tin người dùng vào Hive
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _openBoxes();
    await _userInfoBox?.put('userInfo', userInfo);
  }

  // Lấy thông tin người dùng từ Hive
  static Future<Map<String, dynamic>?> getUserInfoFromHive() async {
    await _openBoxes();
    return _userInfoBox?.get('userInfo') as Map<String, dynamic>?;
  }

  // Cập nhật thông tin người dùng trong Hive
  static Future<void> updateUserInfo(Map<String, dynamic> userInfo) async {
    await _openBoxes();
    await _userInfoBox?.put('userInfo', userInfo);
  }

  // Xóa thông tin người dùng từ Hive
  static Future<void> deleteUserInfo() async {
    await _openBoxes();
    await _userInfoBox?.delete('userInfo');
  }
}
