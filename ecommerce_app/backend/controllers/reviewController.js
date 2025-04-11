const Product = require('../models/product');

// 1. Lấy tất cả các review của sản phẩm
const getReviewsByProductId = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.status(200).json(product.reviews);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching reviews', error: err });
  }
};

// 2. Thêm đánh giá vào sản phẩm
const addReviewToProduct = async (req, res) => {
  const { rating, comment, userName } = req.body;
  
  try {
    const product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    const review = {
      rating,
      comment,
      userName,
      createdAt: new Date(),
    };

    product.reviews.push(review);
    await product.save();
    
    res.status(201).json({ message: 'Review added successfully', review });
  } catch (err) {
    res.status(500).json({ message: 'Error adding review', error: err });
  }
};

module.exports = {
  getReviewsByProductId,
  addReviewToProduct,
};
