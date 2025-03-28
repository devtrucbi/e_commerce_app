import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  double _price = 0.0;
  String _category = '';
  String _status = '';
  final List<String> _imageUrls = []; // Lưu trữ URL ảnh
  final List<String> _variants = [];
  double _rating = 1.0;
  final _imageUrlController = TextEditingController();

  // Hàm thêm sản phẩm
  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_imageUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide at least one image URL.')),
        );
        return;
      }

      // Gọi API để thêm sản phẩm vào backend
      final result = await ApiService.addProduct(
        name: _name,
        description: _description,
        price: _price,
        category: _category,
        status: _status,
        images: _imageUrls,
        variants: _variants,
        rating: _rating,
      );

      if (result) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Product added successfully!')));
        Navigator.pop(context); // Quay lại màn hình trước
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add product')));
      }
    }
  }

  // Hàm để thêm URL ảnh vào danh sách
  void _addImageUrl() {
    if (_imageUrlController.text.isNotEmpty) {
      setState(() {
        _imageUrls.add(_imageUrlController.text);
      });
      _imageUrlController.clear(); // Xóa trường nhập sau khi thêm
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                // Mô tả sản phẩm
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                // Giá sản phẩm
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),
                // Phân loại sản phẩm
                TextFormField(
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product category';
                    }
                    return null;
                  },
                  onSaved: (value) => _category = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product status';
                    }
                    return null;
                  },
                  onSaved: (value) => _category = value!,
                ),
                // Nhập URL của ảnh sản phẩm
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(labelText: 'Enter Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                // Nút để thêm URL ảnh vào danh sách
                TextButton(
                  onPressed: _addImageUrl,
                  child: Text('Add Image URL'),
                ),
                // Hiển thị ảnh đã thêm
                _imageUrls.isEmpty
                    ? Text('No images added.')
                    : Column(
                      children:
                          _imageUrls.map((url) {
                            return Image.network(
                              url,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                    ),
                SizedBox(height: 20),
                // Các biến thể sản phẩm (ví dụ: màu sắc, kích thước)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Variant (e.g. Color, Size)',
                  ),
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      setState(() {
                        _variants.add(value);
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                // Đánh giá sản phẩm (rating)
                Text('Rating: $_rating'),
                Slider(
                  value: _rating,
                  min: 1.0,
                  max: 5.0,
                  divisions: 4,
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Nút thêm sản phẩm
                ElevatedButton(
                  onPressed: _addProduct,
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
