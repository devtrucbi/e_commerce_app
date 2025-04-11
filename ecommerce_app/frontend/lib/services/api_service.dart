import 'dart:convert';
import 'package:ecommerce_app/services/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://localhost:5001/api'; // URL backend của bạn

  // Lấy danh sách sản phẩm từ backend và lưu vào SQLite nếu có kết nối internet
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("Dữ liệu nhận từ API: $data"); // In ra dữ liệu để kiểm tra
        await DatabaseHelper.instance.insertProducts(
          data.map((item) => item as Map<String, dynamic>).toList(),
        );
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Lỗi API: ${response.statusCode}");
        return await DatabaseHelper.instance.getProducts();
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return await DatabaseHelper.instance.getProducts();
    }
  }

  // Lấy chi tiết sản phẩm theo ID từ backend và lưu vào SQLite nếu có kết nối internet
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
      // Nếu không có kết nối API, lấy dữ liệu từ SQLite
      throw Exception('Error fetching product detail');
    }
  }

  // Lấy các sản phẩm theo danh mục (category)
  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(
    String category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Lưu vào SQLite
        await DatabaseHelper.instance.insertProducts(
          data.map((item) => item as Map<String, dynamic>).toList(),
        );

        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        // Nếu không có kết nối API, lấy dữ liệu từ SQLite
        return await DatabaseHelper.instance.getProducts();
      }
    } catch (e) {
      // Nếu không có kết nối API, lấy dữ liệu từ SQLite
      return await DatabaseHelper.instance.getProducts();
    }
  }

  // Đăng ký người dùng
  static Future<bool> registerUser({
    required String email,
    required String fullName,
    required String address,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'), // Đảm bảo đường dẫn chính xác
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'fullName': fullName,
          'address': address,
          'password': password, // Chắc chắn gửi mật khẩu
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Lỗi từ backend: ${response.body}'); // In ra lỗi chi tiết
        throw Exception('Đăng ký không thành công');
      }
    } catch (e) {
      print('Lỗi đăng ký: $e'); // In ra lỗi nếu có
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
        return data['token']; // Trả về token
      } else {
        throw Exception('Đăng nhập không thành công');
      }
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      throw Exception('Lỗi đăng nhập');
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
    String? cpu,
    String? ram,
    String? vga,
    String? storage,
    String? monitorSize,
    String? screenResolution, // Thêm trường screenResolution
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
        'stock': stock, // Thêm tham số stock
        'sold': sold, // Thêm tham số sold
        'cpu': cpu,
        'ram': ram,
        'vga': vga,
        'storage': storage,
        'monitorSize': monitorSize,
        'screenResolution': screenResolution, // Truyền trường screenResolution
        'refreshRate': refreshRate,
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

  // Inside ApiService

  // Lấy tên người dùng từ token
  // static Future<String> _getUserNameFromToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final decodedToken = json.decode(token);
  //   return decodedToken['name']; // Assuming 'name' is stored in token
  // }

  static Future<Map<String, dynamic>> getUserInfo(String token) async {
    var response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  static Future<bool> addProductToCart({
    required String productId,
    required int quantity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'productId': productId, 'quantity': quantity}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to add product to cart');
    }
  }

  //TÍCH HỢP API VỚI SQFLITE
  static Future<void> syncProducts() async {
    var uri = Uri.parse('$baseUrl/products');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> productsData = json.decode(response.body);
      for (var product in productsData) {
        await DatabaseHelper.instance.addProduct({
          'name': product['name'],
          'description': product['description'],
          'category': product['category'],
          'status': product['status'],
          'oldprice': product['oldprice'],
          'newprice': product['newprice'],
          'discount': product['discount'],
          'images': json.encode(product['images']),
          'variants': json.encode(product['variants']),
          'rating': product['rating'],
          'stock': product['stock'],
          'sold': product['sold'],
          'cpu': product['cpu'],
          'ram': product['ram'],
          'vga': product['vga'],
          'storage': product['storage'],
          'monitor_size': product['monitor_size'],
          'screen_resolution': product['screen_resolution'],
          'refresh_rate': product['refresh_rate'],
          'screen_size': product['screen_size'],
          'resolution': product['resolution'],
        });
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Lấy sản phẩm từ SQLite
  static Future<List<Map<String, dynamic>>> getProductsFromSQLite() async {
    return await DatabaseHelper.instance.getProducts();
  }

  // Thêm đánh giá sản phẩm
  static Future<void> submitReview({
    required String productId,
    required int rating,
    required String comment,
    required String userName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/$productId/reviews'), // Correct endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rating': rating,
          'comment': comment,
          'userName': userName,
        }),
      );

      if (response.statusCode == 201) {
        // Đánh giá được gửi thành công, lưu vào SQLite
        var review = json.decode(response.body);
        await DatabaseHelper.instance.addReview({
          'productId': productId,
          'rating': review['rating'],
          'comment': review['comment'],
          'userName': review['userName'],
          'createdAt': review['createdAt'],
        });
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

  // Lấy tất cả bình luận của sản phẩm từ API và lưu vào SQLite
  static Future<List<Map<String, dynamic>>> getProductReviews({
    required String productId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId/reviews'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Lưu dữ liệu đánh giá vào SQLite
        for (var review in data) {
          await DatabaseHelper.instance.addReview({
            'productId': productId,
            'rating': review['rating'],
            'comment': review['comment'],
            'userName': review['userName'],
            'createdAt': review['createdAt'],
          });
        }
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      throw Exception('Error fetching reviews');
    }
  }

  // Lấy đánh giá từ SQLite nếu không có kết nối Internet
  static Future<List<Map<String, dynamic>>> getReviewsFromSQLite(
    int productId,
  ) async {
    return await DatabaseHelper.instance.getReviews(productId);
  }

  // Lấy danh sách sản phẩm từ SQLite và in ra console
  static Future<void> printProductsFromSQLite() async {
    try {
      // Lấy danh sách sản phẩm từ SQLite
      List<Map<String, dynamic>> products =
          await DatabaseHelper.instance.getProducts();

      // In ra console để kiểm tra dữ liệu
      print("Sản phẩm từ SQLite:");
      products.forEach((product) {
        print(
          'ID: ${product['_id']}, Name: ${product['name']}, Description: ${product['description']}',
        );
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu từ SQLite: $e');
    }
  }
}
