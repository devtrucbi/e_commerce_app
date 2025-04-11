const isAdmin = (req, res, next) => {
    // Kiểm tra nếu người dùng có quyền admin
    if (req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Bạn không có quyền truy cập' });
    }
    next(); // Cho phép tiếp tục nếu là admin
  };
  
  module.exports = isAdmin;
  