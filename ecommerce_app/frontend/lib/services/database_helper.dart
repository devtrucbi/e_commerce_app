import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Xóa cơ sở dữ liệu cũ nếu có
    await _deleteDatabaseFile();
    _database = await _initDB('ecommerce_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final path = join(dbDirectory.path, filePath);
    print("Database path: $path"); // In đường dẫn cơ sở dữ liệu

    // Mở cơ sở dữ liệu với quyền ghi (write)
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Tạo bảng trong SQLite cho sản phẩm và đánh giá
  Future _onCreate(Database db, int version) async {
    const String reviewTable = '''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rating INTEGER NOT NULL,
        comment TEXT NOT NULL,
        userName TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        productId TEXT NOT NULL  
      );
    ''';

    const String productTable = '''
      CREATE TABLE products (
        _id TEXT PRIMARY KEY, 
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        status TEXT NOT NULL,
        oldprice INTEGER NOT NULL,
        newprice INTEGER NOT NULL,
        discount INTEGER DEFAULT 0,
        images TEXT,  -- Store as JSON string
        variants TEXT,  -- Store as JSON string
        rating REAL DEFAULT 4.5,
        stock INTEGER NOT NULL,
        sold INTEGER DEFAULT 0,
        cpu TEXT DEFAULT '',
        ram TEXT DEFAULT '',
        vga TEXT DEFAULT '',
        storage TEXT DEFAULT '',
        monitor_size TEXT DEFAULT '',
        screen_resolution TEXT DEFAULT '',
        refresh_rate TEXT DEFAULT '',
        screen_size TEXT DEFAULT '',
        resolution TEXT DEFAULT ''
      );
    ''';

    await db.execute(reviewTable);
    await db.execute(productTable);
  }

  // Hàm xử lý bản đồ sản phẩm trước khi lưu vào SQLite:
  Map<String, dynamic> _prepareProductForInsert(Map<String, dynamic> product) {
    Map<String, dynamic> newProduct = Map<String, dynamic>.from(product);

    // Loại bỏ trường reviews nếu có
    newProduct.remove('reviews');

    // Loại bỏ trường __v nếu có
    newProduct.remove('__v');

    // Nếu 'images' là List, chuyển nó thành JSON string
    if (newProduct.containsKey('images') && newProduct['images'] is List) {
      newProduct['images'] = json.encode(newProduct['images']);
    }

    // Nếu 'variants' là List, chuyển nó thành JSON string
    if (newProduct.containsKey('variants') && newProduct['variants'] is List) {
      newProduct['variants'] = json.encode(newProduct['variants']);
    }

    // Convert ObjectId (_id) to String
    if (newProduct.containsKey('_id')) {
      newProduct['_id'] =
          newProduct['_id'].toString(); // Convert MongoDB ObjectId to String
    }

    return newProduct;
  }

  // Thêm sản phẩm vào SQLite
  Future<int> addProduct(Map<String, dynamic> product) async {
    final db = await database;
    Map<String, dynamic> newProduct = _prepareProductForInsert(product);
    return await db.insert('products', newProduct);
  }

  // Thêm danh sách sản phẩm vào SQLite
  Future<void> insertProducts(List<Map<String, dynamic>> products) async {
    final db = await database;
    for (var product in products) {
      try {
        Map<String, dynamic> newProduct = _prepareProductForInsert(product);
        await db.insert(
          'products',
          newProduct,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("Sản phẩm đã được lưu: $newProduct"); // In ra sản phẩm đã lưu
      } catch (e) {
        print("Lỗi khi lưu sản phẩm vào SQLite: $e"); // In ra lỗi nếu có
      }
    }
  }

  // Lấy tất cả sản phẩm
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    List<Map<String, dynamic>> products = await db.query('products');
    print("Sản phẩm trong SQLite: $products");
    for (var product in products) {
      if (product['images'] != null) {
        try {
          product['images'] = List<String>.from(json.decode(product['images']));
        } catch (e) {
          product['images'] = [];
        }
      }
      if (product['variants'] != null) {
        try {
          product['variants'] = List<String>.from(
            json.decode(product['variants']),
          );
        } catch (e) {
          product['variants'] = [];
        }
      }
    }
    return products;
  }

  // Hàm upgrade để xóa bảng cũ và tạo lại bảng mới
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Kiểm tra nếu bảng products tồn tại, xóa bảng cũ
      await db.execute('DROP TABLE IF EXISTS products');
      await db.execute('DROP TABLE IF EXISTS reviews');
      // Tạo lại bảng với cấu trúc mới
      await _onCreate(db, newVersion);
    }
  }

  // Xóa cơ sở dữ liệu (thủ công)
  Future<void> _deleteDatabaseFile() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final path = join(dbDirectory.path, 'ecommerce_app.db');
    try {
      await deleteDatabase(path); // Xóa cơ sở dữ liệu SQLite
      print("Cơ sở dữ liệu đã được xóa.");
    } catch (e) {
      print("Lỗi khi xóa cơ sở dữ liệu: $e");
    }
  }

  // Thêm đánh giá vào SQLite
  Future<int> addReview(Map<String, dynamic> review) async {
    final db = await database;
    return await db.insert('reviews', review);
  }

  // Lấy tất cả đánh giá của một sản phẩm
  Future<List<Map<String, dynamic>>> getReviews(int productId) async {
    final db = await database;
    return await db.query(
      'reviews',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }
}
