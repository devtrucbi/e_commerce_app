const express = require('express');
const router = express.Router();
const ProductController = require('../controllers/productController');

// Lấy danh sách sản phẩm
router.get('/', ProductController.getProducts);

// Lấy sản phẩm theo danh mục
router.get('/category/:category', ProductController.getProductsByCategory);

// Thêm sản phẩm mới
router.post('/', ProductController.addProduct);

// Cập nhật sản phẩm
router.put('/:id', ProductController.updateProduct);

// Xóa sản phẩm
router.delete('/:id', ProductController.deleteProduct);

// Lấy sản phẩm khuyến mãi (có discount)
router.get('/promotions', ProductController.getPromotionalProducts);

module.exports = router;
