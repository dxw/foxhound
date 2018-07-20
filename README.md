# dxw Foxhound

Prototype for local council payments using GOV.UK Pay

## Requirements

- Ruby
- Postgres
- [GOV.UK Pay API key](https://selfservice.payments.service.gov.uk/api-keys)

## Installation

- Clone the repository
- Copy the `.env.example` to `.env`
- Paste in the GOV.UK Pay API key
- Install dependencies `bundle install && npm install`
- Setup the database `bundle exec rake db:setup`
- Start the dev server `rackup -p 4567` 
- Alternatively install [`shotgun`](https://github.com/rtomayko/shotgun) for automatically reloading
