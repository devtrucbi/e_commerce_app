const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  category: { type: String, required: true },
  status: { type: String, required: true },
  discount: { type: Number, default: 0, max: 50 },  // Discount, with a max limit of 50%
  oldprice: { type: Number, required: true },
  newprice: { type: Number, required: true },
  images: { type: [String], required: true },
  variants: { type: [String] },
  rating: { type: Number, default: 0 },
  stock: { type: Number, default: 0 }, // Thêm trường số lượng tồn kho
  sold: { type: Number, default: 0 },
});

const Product = mongoose.model('Product', productSchema);
module.exports = Product;
