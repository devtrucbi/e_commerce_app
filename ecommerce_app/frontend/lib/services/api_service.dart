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
      // Nếu yêu cầu thành công, trả về danh sách sản phẩm dưới dạng JSON
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(
    String category,
  ) async {
    var uri = Uri.parse(
      '$baseUrl/products/category/$category',
    ); // Gửi yêu cầu GET đến backend với danh mục
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  // Thêm sản phẩm mới vào backend
  static Future<bool> addProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required List<String> images,
    required List<String> variants,
    required double rating,
  }) async {
    var uri = Uri.parse('$baseUrl/products');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'images': images.join(','),
        'variants': variants.join(','),
        'rating': rating,
      }),
    );

    return response.statusCode == 200; // Kiểm tra mã trạng thái trả về
  }
}
