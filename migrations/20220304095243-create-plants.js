module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Plants', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      species: {
        type: Sequelize.STRING,
      },
      colour: {
        type: Sequelize.STRING,
      },
      size: {
        type: Sequelize.STRING,
      },
      season: {
        type: Sequelize.BOOLEAN,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('Plants');
  },
};
