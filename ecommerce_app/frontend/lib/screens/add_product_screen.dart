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
  String _category = ''; // Loại sản phẩm sẽ được chọn từ dropdown
  String _status = '';
  double _discount = 0.0;
  double _oldPrice = 0.0;
  List<String> _images = [];
  List<String> _variants = [];
  double _rating = 4.5;
  String _imageUrl = ''; // Thêm biến để lưu trữ URL ảnh sản phẩm
  int _stock = 0; // Số lượng tồn kho
  int _sold = 0;

  // Danh sách các loại sản phẩm
  final List<String> _categories = [
    'Laptop',
    'Màn Hình',
    'Ram',
    'Ổ cứng',
    'Bàn phím',
    'PC',
    'Chuột',
  ];

  // Form submission logic
  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final result = await ApiService.addProduct(
        name: _name,
        description: _description,
        oldprice: _oldPrice,
        category: _category, // Lấy loại sản phẩm từ dropdown
        status: _status,
        discount: _discount,
        images: [_imageUrl, ..._images],
        variants: _variants,
        rating: _rating,
        stock: _stock, // Số lượng tồn kho
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 150, 144),
        title: Text("Thêm sản phẩm"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextInput(
                  label: "Tên sản phẩm",
                  onSaved: (value) => _name = value!,
                ),
                _buildTextInput(
                  label: "Mô tả sản phẩm",
                  onSaved: (value) => _description = value!,
                ),
                _buildDropdown(
                  label: "Loại sản phẩm",
                  value: _category,
                  items: _categories,
                  onChanged: (newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
                _buildDropdown(
                  label: "Trạng thái sản phẩm",
                  value: _status,
                  items: ['Mới', 'Cũ'],
                  onChanged: (newValue) {
                    setState(() {
                      _status = newValue!;
                    });
                  },
                ),
                _buildTextInput(
                  label: "Giá sản phẩm",
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _oldPrice = double.parse(value!),
                ),
                _buildTextInput(
                  label: "Giảm giá (%)",
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _discount = double.parse(value!),
                ),
                _buildTextInput(
                  label: "Số lượng tồn kho",
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _stock = int.parse(value!),
                ),
                _buildTextInput(
                  label: "URL ảnh sản phẩm",
                  onSaved: (value) => _imageUrl = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Màu nút
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Thêm sản phẩm"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget cho các TextFormField
  Widget _buildTextInput({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onSaved: onSaved,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  // Widget cho DropdownFormField
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          value: value.isNotEmpty ? value : null,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(child: Text(item), value: item),
                  )
                  .toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng chọn $label";
            }
            return null;
          },
        ),
      ),
    );
  }
}
