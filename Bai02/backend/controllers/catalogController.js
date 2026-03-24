const { getAllCategories } = require("../models/categoryModel");
const { getFeaturedBooks, getBestSellers } = require("../models/bookModel");

async function getHome(req, res) {
  const [categories, featured, bestSellers] = await Promise.all([
    getAllCategories(),
    getFeaturedBooks(6),
    getBestSellers(8)
  ]);

  return res.json({
    categories,
    featured,
    bestSellers
  });
}

module.exports = {
  getHome
};
