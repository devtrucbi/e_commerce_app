const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  rating: { type: Number, required: true },
  comment: { type: String, required: true },
  userName: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  category: { type: String, required: true },
  status: { type: String, required: true },
  oldprice: { type: Number, required: true },
  newprice: { type: Number, required: true },
  discount: { type: Number, default: 0 },
  images: [{type: String}],
  variants: [String],
  rating: { type: Number, default: 4.5 },
  stock: { type: Number, required: true },
  sold: { type: Number, default: 0 },
  reviews: [reviewSchema],
  // Các trường bổ sung:
  cpu: { type: String, default: '' },
  ram: { type: String, default: '' },
  vga: { type: String, default: '' },
  storage: { type: String, default: '' },
  monitor_size: { type: String, default: '' },
  screen_resolution: { type: String, default: '' },
  refresh_rate: { type: String, default: '' },
  // Các trường khác:
  screen_size: { type: String, default: '' },
  resolution: { type: String, default: '' },
});

const Product = mongoose.model('Product', productSchema);

module.exports = Product;
