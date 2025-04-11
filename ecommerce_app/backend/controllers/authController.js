const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

// Đăng ký người dùng mới
const registerUser = async (req, res) => {
  try {
    const { email, fullName, address, password } = req.body;

    // Kiểm tra email đã tồn tại chưa
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email đã tồn tại' });
    }

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      email,
      fullName,
      address,
      password: hashedPassword,
    });

    await newUser.save();
    res.status(201).json({ message: 'Đăng ký thành công' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Lỗi khi đăng ký người dùng', error });
  }
};
// Đăng nhập người dùng
const loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Email không tồn tại.' });
    }

    // Kiểm tra mật khẩu
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Mật khẩu không đúng.' });
    }

    // Tạo JWT token
    const token = jwt.sign({ id: user._id, role: user.role }, 'secret_key', { expiresIn: '1h' });

    res.status(200).json({ message: 'Đăng nhập thành công', token });
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi đăng nhập', error: err });
  }
};

// Cập nhật hồ sơ người dùng
const updateUserProfile = async (req, res) => {
  const { id } = req.params;
  const { fullName, address } = req.body;

  try {
    // Kiểm tra xem người dùng có phải là chủ sở hữu của hồ sơ không hoặc có quyền admin
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: 'Người dùng không tìm thấy' });
    }

    // Cập nhật thông tin
    user.fullName = fullName || user.fullName;
    user.address = address || user.address;

    await user.save();

    res.status(200).json({ message: 'Cập nhật thành công', user });
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi cập nhật hồ sơ', error: err });
  }
};

// Lấy tất cả người dùng (dành cho admin)
const getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách người dùng', error: err });
  }
};

// Xóa người dùng (dành cho admin)
const deleteUser = async (req, res) => {
  const { id } = req.params;

  try {
    const user = await User.findByIdAndDelete(id);
    if (!user) {
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }

    res.status(200).json({ message: 'Xóa người dùng thành công' });
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi xóa người dùng', error: err });
  }
};

// Lấy thông tin người dùng (dành cho người dùng đã đăng nhập)
const getUserInfo = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');  // Tránh trả về mật khẩu
    if (!user) {
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }

    res.status(200).json({
      userName: user.fullName,
      email: user.email,
      address: user.address,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy thông tin người dùng', error });
  }
};



module.exports = {
  registerUser,
  loginUser,
  updateUserProfile,
  getAllUsers,
  deleteUser,
  getUserInfo,
};
