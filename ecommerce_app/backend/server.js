const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const productRoutes = require('./routes/product.js');

const app = express();
app.use(express.json());  // Middleware to parse JSON data
app.use(express.urlencoded({ extended: true }));  // Middleware for form-data (x-www-form-urlencoded)
app.use(cors());

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/ecommerce')
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('Error: ', err));

// Use the product routes for other product related endpoints
app.use('/api/products', productRoutes);

// Start the server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
