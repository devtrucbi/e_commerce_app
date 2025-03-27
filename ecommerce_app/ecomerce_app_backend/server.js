const express = require('express');
const mongoose = require('mongoose');
const multer = require('multer');
const path = require('path');
const Product = require('./models/product');
const cors = require('cors'); 
const productRoutes = require('./routes/product.js');

const app = express();
app.use(express.json());  // Middleware để xử lý dữ liệu JSON
app.use(express.urlencoded({ extended: true }));  // Middleware để xử lý dữ liệu dạng form (x-www-form-urlencoded)
app.use(cors());
// Kết nối MongoDB
mongoose.connect('mongodb://localhost:27017/ecommerce')
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('Error: ', err));
app.use('/api/products', productRoutes);
// Thiết lập Multer để tải ảnh lên
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

// API thêm sản phẩm
app.post('/api/products', upload.array('image', 5), async (req, res) => {
  const { name, description, price, category, rating } = req.body;
  const images = req.files.map(file => file.path); // Lấy tất cả ảnh đã tải lên

  const newProduct = new Product({
    name,
    description,
    price,
    category,
    rating,
    images,
  });

  try {
    const savedProduct = await newProduct.save();
    res.status(200).json(savedProduct);
  } catch (error) {
    res.status(500).json({ message: 'Error adding product', error });
  }
});

// Khởi động server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
