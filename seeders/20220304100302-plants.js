module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Plants', [
      {
        species: 'Monstera',
        colour: 'Green',
        size: 'XL',
        season: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        species: 'Peace Lilly',
        colour: 'Green & White',
        size: 'M',
        season: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ], {});
  },

  async down(queryInterface) {
    await queryInterface.bulkDelete('Plants', null, {});
  },
};
