import 'dart:convert';
import 'package:ecommerce_app/services/hive_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://localhost:5001/api'; // URL backend của bạn

  // -------------------- Product --------------------

  // Lấy danh sách sản phẩm từ backend và lưu vào Hive nếu có kết nối internet
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // print("Dữ liệu nhận từ API: $data"); // In ra dữ liệu để kiểm tra
        await HiveService.saveProducts(data); // Lưu vào Hive
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Lỗi API: ${response.statusCode}");
        return await HiveService.getProducts(); // Lấy từ Hive khi không có kết nối
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return await HiveService.getProducts(); // Lấy từ Hive nếu có lỗi API
    }
  }

  // Lấy chi tiết sản phẩm từ API hoặc Hive khi không có kết nối internet
  static Future<Map<String, dynamic>> getProductDetail(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('No internet connection. Trying to fetch from Hive...');
      var product = await HiveService.getProductDetailFromHive(productId);
      if (product != null) {
        return product;
      } else {
        throw Exception('Product not found in local storage (Hive).');
      }
    }
  }

  // Thêm sản phẩm mới vào backend và Hive
  static Future<bool> addProduct({
    required String name,
    required String description,
    required double oldprice,
    required String category,
    required String status,
    required double discount,
    required List<String> images,
    required List<String> variants,
    required double rating,
    required int stock,
    required int sold,
    String? cpu,
    String? ram,
    String? vga,
    String? storage,
    String? monitorSize,
    String? screenResolution,
    String? refreshRate,
  }) async {
    var response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'description': description,
        'oldprice': oldprice,
        'category': category,
        'status': status,
        'discount': discount,
        'images': images,
        'variants': variants,
        'rating': rating,
        'stock': stock,
        'sold': sold,
        'cpu': cpu,
        'ram': ram,
        'vga': vga,
        'storage': storage,
        'monitorSize': monitorSize,
        'screenResolution': screenResolution,
        'refreshRate': refreshRate,
      }),
    );

    if (response.statusCode == 200) {
      // Save the added product to Hive
      var product = json.decode(response.body);
      await HiveService.saveProducts([product]);
      return true;
    } else {
      return false;
    }
  }

  // Cập nhật sản phẩm
  static Future<bool> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double oldprice,
    required double newprice,
    required String category,
    required String status,
    required double discount,
    required List<String> images,
    required List<String> variants,
    required double rating,
    required int stock,
    required int sold,
  }) async {
    var uri = Uri.parse('$baseUrl/products/$productId');
    var response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'description': description,
        'oldprice': oldprice,
        'newprice': newprice,
        'category': category,
        'status': status,
        'discount': discount,
        'images': images,
        'variants': variants,
        'rating': rating,
        'stock': stock,
        'sold': sold,
      }),
    );

    if (response.statusCode == 200) {
      // Update product in Hive
      var updatedProduct = json.decode(response.body);
      await HiveService.updateProduct(productId, updatedProduct);
      return true;
    } else {
      return false;
    }
  }

  // Xóa sản phẩm
  static Future<bool> deleteProduct(String productId) async {
    var uri = Uri.parse('$baseUrl/products/$productId');
    var response = await http.delete(uri);

    if (response.statusCode == 200) {
      // Delete product from Hive
      await HiveService.deleteProduct(productId);
      return true;
    } else {
      return false;
    }
  }

  // -------------------- User --------------------

  // Đăng ký người dùng
  static Future<bool> registerUser({
    required String email,
    required String fullName,
    required String address,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'fullName': fullName,
          'address': address,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Lưu thông tin người dùng vào Hive sau khi đăng ký thành công
        var userInfo = json.decode(response.body);
        await HiveService.saveUserInfo(userInfo);
        return true;
      } else {
        print('Lỗi từ backend: ${response.body}');
        throw Exception('Đăng ký không thành công');
      }
    } catch (e) {
      print('Lỗi đăng ký: $e');
      throw Exception('Lỗi đăng ký');
    }
  }

  // Đăng nhập người dùng
  static Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Lưu token vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', data['token']); // Lưu token
        return data['token']; // Trả về token
      } else {
        throw Exception('Đăng nhập không thành công');
      }
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      throw Exception('Lỗi đăng nhập');
    }
  }

  // -------------------- Review --------------------

  // Thêm đánh giá sản phẩm
  static Future<void> submitReview({
    required String productId,
    required int rating,
    required String comment,
    required String userName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/$productId/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rating': rating,
          'comment': comment,
          'userName': userName,
        }),
      );

      if (response.statusCode == 201) {
        // Lưu vào Hive
        var review = json.decode(response.body);
        await HiveService.saveReview(productId, review);
        print('Review submitted and saved locally');
      } else {
        print('Failed to submit review: ${response.body}');
        throw Exception('Failed to submit review');
      }
    } catch (e) {
      print('Error submitting review: $e');
      throw Exception('Error submitting review');
    }
  }

  // Lấy tất cả bình luận của sản phẩm từ API và lưu vào Hive
  static Future<List<Map<String, dynamic>>> getProductReviews({
    required String productId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId/reviews'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        await HiveService.saveReviews(productId, data); // Lưu vào Hive
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      return await HiveService.getReviewsFromHive(
        productId,
      ); // Lấy từ Hive khi không có kết nối
    }
  }

  // -------------------- Sync --------------------

  // Đồng bộ sản phẩm từ API về Hive
  static Future<void> syncProducts() async {
    var uri = Uri.parse('$baseUrl/products');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> productsData = json.decode(response.body);
      await HiveService.saveProducts(productsData);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Lấy thông tin người dùng từ API và lưu vào Hive nếu có kết nối internet
  static Future<Map<String, dynamic>> getUserInfo(String token) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userInfo = json.decode(response.body);

        // Lưu thông tin người dùng vào Hive
        await HiveService.saveUserInfo(userInfo);

        return userInfo;
      } else {
        throw Exception('Failed to load user info');
      }
    } catch (e) {
      print('Error fetching user info: $e');

      // Nếu không có kết nối Internet, lấy thông tin người dùng từ Hive
      var userInfo = await HiveService.getUserInfoFromHive();

      if (userInfo != null) {
        return userInfo;
      } else {
        throw Exception('Failed to fetch user info from local storage');
      }
    }
  }

  // -------------------- Utility --------------------

  // In danh sách sản phẩm từ Hive
  static Future<void> printProductsFromHive() async {
    try {
      List<Map<String, dynamic>> products = await HiveService.getProducts();
      print("Sản phẩm từ Hive:");
      products.forEach((product) {
        print(
          'ID: ${product['_id']}, Name: ${product['name']}, Description: ${product['description']}',
        );
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu từ Hive: $e');
    }
  }
}
