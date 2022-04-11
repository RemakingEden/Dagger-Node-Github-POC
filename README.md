# Eden in Express/Postgres/Jest/Supertest

[![Open in Visual Studio Code](https://img.shields.io/static/v1?logo=visualstudiocode&label=&message=Open%20in%20Visual%20Studio%20Code&labelColor=2c2c32&color=007acc&logoColor=007acc)](https://open.vscode.dev/jpb06/jest-badges-action)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=RemakingEden_Eden-in-Express-Postgres-Sequelize-Jest-Supertest&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=RemakingEden_Eden-in-Express-Postgres-Sequelize-Jest-Supertest)

Eden is a mock plant shop. It is an example of a very basic REST API with integration tests. My hope is to make a test framework that can be scaled.

## Installation

Ensure you have [Node & NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) installed.

```bash
npm install
```

```bash
docker-compose up -d
```

## Usage
See the package.json for all available commands

```bash
# Set up the database

# Create the sb
npm run db:create

# Set up the tables
npm run migrate

# Set up some very basic seeded data 
npm run seed
```

```bash
# General server use

# Start the server using nodemon
npm start 

# returns all plants
curl localhost:3000/api/plants

# returns a specific plant
curl localhost:3000/api/plants/1

# Adds a plant to the db
curl -X POST localhost:3000/api/plants\
    -H 'Content-Type: application/json'\
   -d '{"species": "Boston Fern","colour": "Green","size": "S","season": true}'

# Update a plant in the db
curl -X PUT localhost:3000/api/plants/1\
    -H 'Content-Type: application/json'\
   -d '{"species": "Cactus","colour": "Purple","size": "L","season": false}'

# Delete a plant in the db
curl -X DELETE localhost:3000/api/plants/1
```
```bash
# Using the test suite

# Run all tests
npm test

# Update the snapshots
npm test -- -u

# Start Jest in interactive watch mode
npm test -- --watch
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
