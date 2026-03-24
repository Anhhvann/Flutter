const express = require("express");
const catalogController = require("../controllers/catalogController");

const router = express.Router();

router.get("/home", catalogController.getHome);

module.exports = router;
