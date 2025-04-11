const express = require('express');
const router = express.Router();
const UserController = require('../controllers/authController');
const isAuthenticated = require('../middleware/isAuthenticated'); // Import middleware xác thực người dùng
const isAdmin = require('../middleware/isAdmin'); // Import middleware kiểm tra quyền admin

// Đăng ký người dùng
router.post('/register', UserController.registerUser);

// Đăng nhập người dùng
router.post('/login', UserController.loginUser);
//Lấy thông tin người dùng
router.get('/me', isAuthenticated, UserController.getUserInfo);

// Cập nhật hồ sơ người dùng (chỉ người dùng đã đăng nhập hoặc admin có thể thay đổi)
router.put('/users/:id', isAuthenticated, UserController.updateUserProfile);

// Các route quản trị viên (chỉ admin có quyền truy cập)
router.get('/users', isAuthenticated, isAdmin, UserController.getAllUsers);  // Lấy danh sách người dùng
router.delete('/users/:id', isAuthenticated, isAdmin, UserController.deleteUser);  // Xóa người dùng

module.exports = router;
