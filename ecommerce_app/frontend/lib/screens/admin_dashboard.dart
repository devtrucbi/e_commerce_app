import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Product'),
          content: AddProductForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Các mục quản lý khác của trang admin có thể được thêm ở đây
            Text('Admin Dashboard'),
            SizedBox(height: 20),

            // Nút để thêm sản phẩm
            ElevatedButton(
              onPressed: () {
                _showAddProductDialog(context); // Hiển thị form thêm sản phẩm
              },
              child: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Form để thêm sản phẩm
class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  double _price = 0.0;
  String _category = '';
  String _status = '';
  double _discount = 0.0;
  final _imageUrlController = TextEditingController();

  // Hàm gửi sản phẩm lên backend
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Thực hiện gọi API để thêm sản phẩm
      bool success = await ApiService.addProduct(
        name: _name,
        description: _description,
        oldprice: _price,
        category: _category,
        status: _status,
        discount: _discount,
        images: [_imageUrlController.text], // Giả sử chỉ có một ảnh
        variants: [], // Có thể thay đổi nếu có biến thể
        rating: 5.0, // Giả sử đánh giá là 5
        stock: 100, // Giả sử còn hàng 100 sản phẩm
        sold: 0,
      );

      if (success) {
        // Đóng dialog sau khi thêm sản phẩm thành công
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Product added successfully!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add product')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
          // Danh mục sản phẩm
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
          // Giảm giá sản phẩm
          TextFormField(
            decoration: InputDecoration(labelText: 'Discount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter product discount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid discount';
              }
              return null;
            },
            onSaved: (value) => _discount = double.parse(value!),
          ),
          // URL hình ảnh sản phẩm
          TextFormField(
            controller: _imageUrlController,
            decoration: InputDecoration(labelText: 'Image URL'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter image URL';
              }
              return null;
            },
          ),
          // Nút gửi form
          SizedBox(height: 20),
          ElevatedButton(onPressed: _submitForm, child: Text('Add Product')),
        ],
      ),
    );
  }
}
