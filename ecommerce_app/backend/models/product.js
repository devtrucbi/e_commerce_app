const mongoose = require('mongoose');

// Định nghĩa schema cho sản phẩm
const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  category: { type: String, required: true },
  images: [String],    // Mảng chứa URL ảnh
  variants: [String],  // Các biến thể của sản phẩm (màu sắc, kích thước, v.v.)
  rating: { type: Number, min: 1, max: 5, default: 1 },
});

// Tạo mô hình sản phẩm từ schema
module.exports = mongoose.model('Product', productSchema);
