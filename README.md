# README

## Requirements

- docker and docker-compose

## Steps for first start
1. Make sure you have docker and docker-compose installed and running
2. Copy `env-example` to `.env`
3. Run `docker-compose build`
4. Run `docker-compose run --rm web rails db:setup`, to create database, load schema and seed some data
5. `docker-compose up` to start server
6. Got to http://localhost:3000