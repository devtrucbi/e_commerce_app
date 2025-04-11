const express = require('express');
const router = express.Router();
const ProductController = require('../controllers/productController');
const reviewController = require('../controllers/reviewController');

// Lấy danh sách sản phẩm
router.get('/', ProductController.getProducts);

// Lấy sản phẩm theo danh mục
router.get('/category/:category', ProductController.getProductsByCategory);

router.get('/:_id', ProductController.getProductById)

// Thêm sản phẩm mới
router.post('/', ProductController.addProduct);

// Cập nhật sản phẩm
router.put('/:id', ProductController.updateProduct);

// Xóa sản phẩm
router.delete('/:id', ProductController.deleteProduct);

// Lấy sản phẩm khuyến mãi (có discount)
router.get('/promotions', ProductController.getPromotionalProducts);
//Lấy review sản phẩm
router.get('/:id/reviews', reviewController.getReviewsByProductId);
router.post('/:id/reviews', reviewController.addReviewToProduct);

module.exports = router;
