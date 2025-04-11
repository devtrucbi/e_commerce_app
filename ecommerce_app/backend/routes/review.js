const express = require('express');
const router = express.Router();
const { addReview, getReviews, updateReview, deleteReview } = require('../controllers/reviewController');
const authMiddleware = require('../middlewares/isAuthenticated');

// Thêm đánh giá (cần đăng nhập)
router.post('/products/:id/reviews', authMiddleware, addReview);

// Lấy tất cả đánh giá của sản phẩm
router.get('/products/:id/reviews', getReviews);

// Cập nhật đánh giá (cần đăng nhập)
router.put('/reviews/:reviewId', authMiddleware, updateReview);

// Xóa đánh giá (cần đăng nhập)
router.delete('/reviews/:reviewId', authMiddleware, deleteReview);

module.exports = router;
