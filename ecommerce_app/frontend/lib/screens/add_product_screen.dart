import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _category = '';
  String _status = '';
  double _discount = 0.0;
  double _oldPrice = 0.0;
  List<String> _images = [];
  List<String> _variants = [];
  double _rating = 4.5;
  String _imageUrl = ''; // Thêm biến để lưu trữ URL ảnh sản phẩm
  int _stock = 0;
  int _sold = 0;

  // Form submission logic
  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final result = await ApiService.addProduct(
        name: _name,
        description: _description,
        oldprice: _oldPrice,
        category: _category,
        status: _status,
        discount: _discount,
        images: [_imageUrl, ..._images],
        variants: _variants,
        rating: _rating,
        stock: _stock,
        sold: _sold,
      );
      if (result) {
        // Show success message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Thêm sản phẩm thành công!')));
      } else {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Thêm sản phẩm thất bại')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thêm sản phẩm")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Tên sản phẩm"),
                onSaved: (value) => _name = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập tên sản phẩm";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Mô tả sản phẩm"),
                onSaved: (value) => _description = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập mô tả sản phẩm";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Danh mục sản phẩm"),
                onSaved: (value) => _category = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập phân loại sản phẩm";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Trạng thái sản phẩm"),
                value: _status.isNotEmpty ? _status : null,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items:
                    ['Mới', 'Cũ']
                        .map(
                          (status) => DropdownMenuItem(
                            child: Text(status),
                            value: status,
                          ),
                        )
                        .toList(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Giá sản phẩm"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _oldPrice = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập giá sản phẩm";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Giảm giá (%)"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _discount = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập giảm giá";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "URL ảnh sản phẩm"),
                onSaved: (value) => _imageUrl = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập URL ảnh sản phẩm";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitProduct,
                child: Text("Thêm sản phẩm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
