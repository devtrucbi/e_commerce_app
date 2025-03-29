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
  const { name, description, category, status, discount, oldprice, images, variants, rating } = req.body;

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
  });

  try {
    const savedProduct = await newProduct.save(); // Lưu sản phẩm vào cơ sở dữ liệu
    res.status(200).json(savedProduct);  // Trả về sản phẩm vừa được thêm
  } catch (err) {
    res.status(500).json({ message: 'Error adding product', error: err });
  }
};

// 4. Cập nhật thông tin sản phẩm
const updateProduct = async (req, res) => {
  const { name, description, category, status, discount, oldprice, images, variants, rating } = req.body;
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
      },
      { new: true }  // Trả về sản phẩm sau khi được cập nhật
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

module.exports = {
  getProducts,
  getProductsByCategory,
  addProduct,
  updateProduct,
  deleteProduct,
  getPromotionalProducts,
};
