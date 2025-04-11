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
  double _rating = 0;
  String _imageUrl = '';
  int _stock = 0;
  int _sold = 0;
  String _cpu = '';
  String _ram = '';
  String _vga = '';
  String _storage = '';
  String _monitorSize = '';
  String _screenResolution = '';
  String _refreshRate = '';

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
        cpu: _cpu,
        ram: _ram,
        vga: _vga,
        storage: _storage,
        monitorSize: _monitorSize,
        screenResolution: _screenResolution,
        refreshRate: _refreshRate,
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

                // Các trường bổ sung cho các loại sản phẩm
                if (_category == 'Laptop' || _category == 'PC') ...[
                  _buildTextInput(
                    label: "CPU",
                    onSaved: (value) => _cpu = value!,
                  ),
                  _buildTextInput(
                    label: "RAM",
                    onSaved: (value) => _ram = value!,
                  ),
                  _buildTextInput(
                    label: "VGA",
                    onSaved: (value) => _vga = value!,
                  ),
                  _buildTextInput(
                    label: "Ổ cứng",
                    onSaved: (value) => _storage = value!,
                  ),
                ],
                if (_category == 'Màn Hình') ...[
                  _buildTextInput(
                    label: "Kích thước màn hình",
                    onSaved: (value) => _monitorSize = value!,
                  ),
                  _buildTextInput(
                    label: "Độ phân giải",
                    onSaved: (value) => _screenResolution = value!,
                  ),
                  _buildTextInput(
                    label: "Tần số quét",
                    onSaved: (value) => _refreshRate = value!,
                  ),
                ],
                if (_category == 'Ram' || _category == 'Ổ cứng') ...[
                  _buildDropdown(
                    label: "Dung lượng",
                    value: _category == 'Ram' ? _ram : _storage,
                    items:
                        _category == 'Ram'
                            ? ['8GB', '16GB']
                            : ['256GB', '512GB', '1TB', '2TB'],
                    onChanged: (newValue) {
                      setState(() {
                        if (_category == 'Ram') {
                          _ram = newValue!;
                        } else {
                          _storage = newValue!;
                        }
                      });
                    },
                  ),
                ],

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 234, 150, 144),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                    elevation: 8,
                    shadowColor: Colors.white,
                    side: BorderSide(width: 2, color: Colors.black),
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
