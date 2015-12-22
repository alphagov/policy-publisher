# Policy publisher

The policy publisher exists to create and manage policies and sub-policies
through the Publishing 2.0 pipeline.

## Nomenclature

- **Policy**: a broad overview of an area of government activity eg [domestic energy](https://www.gov.uk/government/policies/helping-households-to-cut-their-energy-bills).
- **Sub-policy**: specific activities the government is taking to support its objectives eg [Green Deal](https://www.gov.uk/government/policies/helping-households-to-cut-their-energy-bills/supporting-pages/green-deal).

## Technical documentation

PostgreSQL-backed Rails 4 "Publishing 2.0" application. It is used by departmental editors.

### Dependencies

- PostgreSQL

### Getting set up

- Run `bundle exec rake db:setup` to create your databases
  and create the default SSO user for dev and test.

### Running the application

- Run `./startup.sh`.  This will start the application on port 3098.

### Running the tests

- Run `bundle exec rake`

### Licence

[MIT Licence](LICENCE.txt)
