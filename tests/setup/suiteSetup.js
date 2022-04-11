/* eslint-disable no-undef */
const models = require('../../models');

afterAll(() => models.sequelize.close());
