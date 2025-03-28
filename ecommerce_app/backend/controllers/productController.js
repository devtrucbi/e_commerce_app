const Product = require('../models/product');

// Lấy danh sách sản phẩm
const getProducts = async (req, res) => {
  try {
    const products = await Product.find(); // Lấy tất cả sản phẩm
    if (products.length === 0) {
      return res.status(404).json({ message: 'No products found' });
    }
    res.status(200).json(products);  // Trả về danh sách sản phẩm
  } catch (err) {
    res.status(500).json({ message: 'Error fetching products', error: err });
  }
};
const getProductsByCategory = async (req, res) => {
    const { category } = req.params;  // Lấy danh mục từ tham số URL
  
    try {
      const products = await Product.find({ category: category }); // Lọc sản phẩm theo danh mục
      if (products.length === 0) {
        return res.status(404).json({ message: 'No products found for this category' });
      }
      res.status(200).json(products);  // Trả về các sản phẩm tìm thấy
    } catch (err) {
      res.status(500).json({ message: 'Error fetching products by category', error: err });
    }
  };
// Thêm sản phẩm mới
const addProduct = async (req, res) => {
  const { name, description, price, category,status, images, variants, rating } = req.body;

  const newProduct = new Product({
    name,
    description,
    price,
    category,
    status,
    images,
    variants,
    rating,
  });

  try {
    const savedProduct = await newProduct.save();
    res.status(200).json(savedProduct); // Trả về sản phẩm đã được thêm
  } catch (err) {
    res.status(500).json({ message: 'Error adding product', error: err });
  }
};

module.exports = {
  getProducts,
  addProduct,
  getProductsByCategory,
};
