const express = require('express');
const router = express.Router();
const { getProducts, addProduct,getProductsByCategory } = require('../controllers/productController'); // Import các phương thức từ controller

// Route GET để lấy danh sách sản phẩm
router.get('/', getProducts);
router.get('/category/:category', getProductsByCategory);
// Route POST để thêm sản phẩm mới
router.post('/', addProduct);

module.exports = router;
