const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  fullName: { type: String, required: true },
  address: { type: String, required: true },
  password: { type: String, required: true },  // Giả sử có mật khẩu
  role: {
    type: String,
    enum: ['user', 'admin'],  // Chỉ cho phép 2 vai trò: user và admin
    default: 'user',  // Mặc định là user
  },
});

const User = mongoose.model('User', userSchema);
module.exports = User;
