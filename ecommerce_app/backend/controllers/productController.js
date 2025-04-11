const Product = require('../models/product');

// 1. Lấy danh sách tất cả sản phẩm
const getProducts = async (req, res) => {
  try {
    const products = await Product.find(); // Lấy tất cả sản phẩm
    if (products.length === 0) {
      return res.status(404).json({ message: 'No products found' });
    }
    res.status(200).json(products); // Trả về danh sách sản phẩm
  } catch (err) {
    res.status(500).json({ message: 'Error fetching products', error: err });
  }
};

// 2. Lấy các sản phẩm theo danh mục (category)
const getProductsByCategory = async (req, res) => {
  const { category } = req.params;  // Lấy danh mục từ tham số URL
  
  try {
    const products = await Product.find({ category: category }); // Lọc sản phẩm theo danh mục
    if (products.length === 0) {
      return res.status(404).json({ message: 'No products found for this category' });
    }
    res.status(200).json(products);  // Trả về các sản phẩm tìm thấy
  } catch (err) {
    res.status(500).json({ message: 'Error fetching products by category', error: err });
  }
};

// 3. Thêm mới một sản phẩm
const addProduct = async (req, res) => {
  const {
    name,
    description,
    category,
    status,
    discount,
    oldprice,
    images,
    variants,
    rating,
    stock,
    sold,
    cpu,
    ram,
    vga,
    storage,
    monitor_size,
    screen_resolution,  // Thêm trường screenResolution
    refresh_rate,       // Thêm trường refreshRate
  } = req.body;


  const newPrice = oldprice - (oldprice * (discount / 100));  // Tính toán giá mới khi có giảm giá

  const newProduct = new Product({
    name,
    description,
    category,
    status,
    discount,
    oldprice,
    newprice: newPrice,
    images,
    variants,
    rating,
    stock,
    sold,
    cpu,
    ram,
    vga,
    storage,
    monitor_size,
    screen_resolution,
    refresh_rate
  });

  try {
    const savedProduct = await newProduct.save();
    res.status(200).json(savedProduct);
  } catch (err) {
    res.status(500).json({ message: 'Error adding product', error: err });
  }
};


// 4. Cập nhật thông tin sản phẩm
const updateProduct = async (req, res) => {
  const { 
    name, description, category, status, discount, oldprice, images, 
    variants, rating, stock, sold, cpu, ram, vga, storage, monitor_size, 
    screen_resolution, refresh_rate 
  } = req.body;
  const { id } = req.params;

  const newPrice = oldprice - (oldprice * (discount / 100));  // Tính toán giá mới khi có giảm giá

  try {
    const updatedProduct = await Product.findByIdAndUpdate(
      id,
      {
        name,
        description,
        category,
        status,
        discount,
        oldprice,
        newprice: newPrice,
        images,
        variants,
        rating,
        stock,
        sold,
        cpu,
        ram,
        vga,
        storage,
        monitor_size,
        screen_resolution,
        refresh_rate
      },
      { new: true }
    );
    res.status(200).json(updatedProduct);
  } catch (err) {
    res.status(500).json({ message: 'Error updating product', error: err });
  }
};

// 5. Xóa sản phẩm
const deleteProduct = async (req, res) => {
  const { id } = req.params;
  
  try {
    await Product.findByIdAndDelete(id);  // Xóa sản phẩm theo ID
    res.status(200).json({ message: 'Product deleted successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Error deleting product', error: err });
  }
};

// 6. Lấy sản phẩm khuyến mãi (có discount)
const getPromotionalProducts = async (req, res) => {
  try {
    const products = await Product.find({ discount: { $gt: 0 } });  // Tìm các sản phẩm có discount > 0
    if (products.length === 0) {
      return res.status(404).json({ message: 'No promotional products found' });
    }
    res.status(200).json(products); // Trả về các sản phẩm khuyến mãi
  } catch (err) {
    res.status(500).json({ message: 'Error fetching promotional products', error: err });
  }
};

// 7. Lấy chi tiết sản phẩm theo ID
const getProductById = async (req, res) => {
  const { _id } = req.params;  // Lấy ID từ tham số URL

  try {
    const product = await Product.findById(_id);  // Tìm sản phẩm theo ID
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.status(200).json(product);  // Trả về chi tiết sản phẩm
  } catch (err) {
    res.status(500).json({ message: 'Error fetching product details', error: err });
  }
};
// 8. Lấy sản phẩm theo thứ tự giá (tăng dần hoặc giảm dần)
const getProductsByPrice = async (req, res) => {
  const { order } = req.query;  // Lấy kiểu sắp xếp từ query parameter (asc hoặc desc)

  try {
    const products = await Product.find().sort({ newprice: order === 'asc' ? 1 : -1 });
    res.status(200).json(products);  // Trả về danh sách sản phẩm đã sắp xếp
  } catch (err) {
    res.status(500).json({ message: 'Error fetching products by price', error: err });
  }
};
// 9. Lọc sản phẩm theo số lượng tồn kho
const getProductsByStock = async (req, res) => {
  try {
    const products = await Product.find({ stock: { $gt: 0 } }); // Tìm các sản phẩm có stock > 0
    if (products.length === 0) {
      return res.status(404).json({ message: 'No products available in stock' });
    }
    res.status(200).json(products);  // Trả về các sản phẩm còn hàng
  } catch (err) {
    res.status(500).json({ message: 'Error fetching products by stock', error: err });
  }
};

// 10. Cập nhật số lượng tồn kho khi bán sản phẩm
const updateProductStock = async (req, res) => {
  const { id } = req.params;  // Lấy ID từ tham số URL
  const { quantitySold } = req.body;  // Lấy số lượng bán từ request body

  try {
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    product.stock -= quantitySold;  // Giảm số lượng tồn kho
    if (product.stock < 0) {
      return res.status(400).json({ message: 'Not enough stock' });
    }

    await product.save();  // Lưu lại sản phẩm với số lượng tồn kho mới
    res.status(200).json({ message: 'Product stock updated successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Error updating product stock', error: err });
  }
};

const getReviewofProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json(product.reviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


module.exports = {
  getProducts,
  getProductsByCategory,
  addProduct,
  updateProduct,
  deleteProduct,
  getPromotionalProducts,
  getProductById,
  getProductsByPrice,
  getProductsByStock,
  updateProductStock,
  getReviewofProduct,
};
