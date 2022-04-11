/* eslint-disable no-undef */
const request = require('supertest');
const app = require('../../app');

describe('Tests with complete DB', () => {
  describe('Tests with GET', () => {
    it('Get list of plants', async () => {
      const res = await request(app).get('/api/plants');
      expect(res.statusCode).toEqual(200);
      expect(res.body).toMatchSnapshot([{
        createdAt: expect.any(String),
        updatedAt: expect.any(String),
      },
      {
        createdAt: expect.any(String),
        updatedAt: expect.any(String),
      }]);
    });
  });

  describe('Tests with POST', () => {
    it('Add a new plant', async () => {
      const res = await request(app).post('/api/plants')
        .send({
          species: 'Boston Fern',
          colour: 'Green',
          size: 'S',
          season: false,
        });
      expect(res.statusCode).toEqual(201);
      expect(res.body).toMatchSnapshot({
        createdAt: expect.any(String),
        updatedAt: expect.any(String),
      });
      // Needs a db check to check post went correctly
    });
  });

  describe('Tests with PUT', () => {
    it('Edit a plant', async () => {
      const res = await request(app).put('/api/plants/1')
        .send({
          species: 'Cactus',
          colour: 'Purple',
          season: true,
        });
      expect(res.statusCode).toEqual(200);
      expect(res.body).toMatchSnapshot({
        createdAt: expect.any(String),
        updatedAt: expect.any(String),
      });
      // Needs a db check to check put went correctly
    });
  });

  describe('Tests with DELETE', () => {
    it('Delete a plant', async () => {
      const res = await request(app).delete('/api/plants/1');
      expect(res.statusCode).toEqual(204);
      // Needs a db check to check delete went correctly
    });
  });
});
