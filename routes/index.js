const express = require('express');

const router = express.Router();

const plantsController = require('../controllers').plants;

/* GET home page. */
router.get('/', (req, res) => {
  res.render('index', { title: 'Express' });
});

router.get('/api/plants', plantsController.list);
router.get('/api/plants/:id', plantsController.getById);
router.post('/api/plants', plantsController.add);
router.put('/api/plants/:id', plantsController.update);
router.delete('/api/plants/:id', plantsController.delete);

module.exports = router;
