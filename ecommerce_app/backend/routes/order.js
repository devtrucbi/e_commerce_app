const express = require('express');
const Order = require('../models/order');

const router = express.Router();

// Tạo đơn hàng
router.post('/', async (req, res) => {
  const { userId, products, totalAmount } = req.body;

  try {
    const newOrder = new Order({ userId, products, totalAmount, status: 'pending' });
    await newOrder.save();

    res.status(201).json(newOrder);
  } catch (error) {
    res.status(500).json({ message: 'Error creating order', error });
  }
});

// Lấy danh sách đơn hàng của người dùng
router.get('/:userId', async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.params.userId });
    res.status(200).json(orders);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching orders', error });
  }
});

module.exports = router;
