const {
  Model,
} = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Plants extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
  }
  Plants.init({
    species: DataTypes.STRING,
    colour: DataTypes.STRING,
    size: DataTypes.STRING,
    season: DataTypes.BOOLEAN,
  }, {
    sequelize,
    modelName: 'Plants',
  });
  return Plants;
};
