const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: { type: String, required: true },
  address: { type: String, required: true },
  role: { type: String, default: 'customer' }, // Role: 'admin' or 'customer'
});

module.exports = mongoose.model('User', userSchema);
