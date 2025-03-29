import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://localhost:5001/api'; // URL backend của bạn

  // Lấy danh sách sản phẩm từ backend
  static Future<List<Map<String, dynamic>>> getProducts() async {
    var uri = Uri.parse('$baseUrl/products');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        // print(data); // In ra để kiểm tra dữ liệu trả về từ API
        return data.map((item) => item as Map<String, dynamic>).toList();
      } catch (e) {
        // print('Error parsing response: $e');
        throw Exception('Failed to parse data');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(
    String category,
  ) async {
    try {
      var uri = Uri.parse('$baseUrl/products/category/$category');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load products by category');
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      throw Exception('Error fetching products by category');
    }
  }

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
    required int stock, // Thêm tham số stock
    required int sold,
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
        'stock': stock, // Thêm tham số stock
        'sold': sold, // Thêm tham số sold
      }),
    );

    return response.statusCode == 200; // Trả về true nếu thêm thành công
  }

  // Xoá sản phẩm
  static Future<bool> deleteProduct(String productId) async {
    var uri = Uri.parse('$baseUrl/products/$productId');
    var response = await http.delete(uri);

    if (response.statusCode == 200) {
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
    required int stock, // Thêm tham số stock
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
        'stock': stock, // Thêm tham số stock
        'sold': sold, // Thêm tham số sold
      }),
    );

    return response.statusCode == 200; // Kiểm tra mã trạng thái trả về
  }
}
