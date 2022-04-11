const { Plants } = require('../models');

module.exports = {
  list(req, res) {
    return Plants
      .findAll()
      .then((plants) => res.status(200).send(plants))
      .catch((error) => { res.status(400).send(error); });
  },

  getById(req, res) {
    return Plants
      .findByPk(req.params.id)
      .then((plants) => {
        if (!plants) {
          return res.status(404).send({
            message: 'Plant Not Found',
          });
        }
        return res.status(200).send(plants);
      })
      .catch((error) => res.status(400).send(error));
  },

  add(req, res) {
    return Plants
      .create({
        species: req.body.species,
        colour: req.body.colour,
        size: req.body.size,
        season: req.body.season,
      })
      .then((plants) => res.status(201).send(plants))
      .catch((error) => res.status(400).send(error));
  },

  update(req, res) {
    return Plants
      .findByPk(req.params.id)
      .then((plants) => {
        if (!plants) {
          return res.status(404).send({
            message: 'Plant Not Found',
          });
        }
        return plants
          .update({
            species: req.body.species || plants.species,
            colour: req.body.colour || plants.colour,
            size: req.body.size || plants.size,
            season: req.body.season || plants.season,
          })
          .then(() => res.status(200).send(plants))
          .catch((error) => res.status(400).send(error));
      })
      .catch((error) => res.status(400).send(error));
  },

  delete(req, res) {
    return Plants
      .findByPk(req.params.id)
      .then((plants) => {
        if (!plants) {
          return res.status(400).send({
            message: 'Plant Not Found',
          });
        }
        return plants
          .destroy()
          .then(() => res.status(204).send())
          .catch((error) => res.status(400).send(error));
      })
      .catch((error) => res.status(400).send(error));
  },
};
