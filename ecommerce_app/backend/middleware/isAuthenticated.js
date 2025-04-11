const jwt = require('jsonwebtoken');

const isAuthenticated = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1]; // Lấy token từ header

  if (!token) {
    return res.status(403).json({ message: 'Bạn cần phải đăng nhập' });
  }

  try {
    const decoded = jwt.verify(token, 'secret_key'); // Kiểm tra token hợp lệ
    req.user = decoded; // Lưu thông tin người dùng vào `req.user`
    next(); // Tiếp tục thực hiện hành động tiếp theo
  } catch (err) {
    return res.status(403).json({ message: 'Token không hợp lệ hoặc hết hạn' });
  }
};

module.exports = isAuthenticated;
