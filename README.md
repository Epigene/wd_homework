# README
A simple task managament app, developed as a "homework" for Workday.

## Things of note
1. API #index endpoints generally implement [cursor pagination](https://jsonapi.org/profiles/ethanresnick/cursor-pagination/) for good performance (as opposed to offset pagination).
2. FK constraints are not used due to sqlite DB, would be on MySQL or Postgres.

## Setup
```
$ rvm install 2.7.4
$ rvm use 2.7.4@wd --create
$ gem update --system
$ bundle
$ rails db:create db:migrate db:seed
```

## Running postman specs
```
$ rails s -b 127.0.0.1 -p 3000
Import 'fixed_postman_tests.json' into postman and run in order, for index action requests expect only the "fixed" tests to pass.
```

## Running RSpec
```
$ COV=1 rspec
# check coverage/ for 100% cov
```

## Running rubocop
```
$ rubocop -c .rubocop.yml
```
