# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### The final branch / stretch goals were built entirely with copilot prompts, summarized below:

#### API

- Add a namespaced controller and API endpoints (routes, etc.) for fetching collections of levels by arbitrary date_scopes, following the existing patterns.
- Update line 6 of the new controller to use the existing from_date_range scope.
- Write tests for this new endpoint (I got RSpec tests here, so followed by:)
- This codebase doesn't use rspec; all other tests are in minitest. Follow this established pattern.
- The levels fixtures referenced in the new test don't exist. Use the existing fixtures, and adjust tested dates to suit those existing fixtures.
- `.expect` won't raise an ActionController::ParameterMissing; it 400's instead. Adjust the test to reflect this behavior.
- Make start_date and end_date into datetime objects (beginning of day, and end of day, respectively).
- Because we're usng beginning_of_day and end_of_day in the scope, the tested dates on line 19 are not returning an empty array, and the test fails. Adjust the tested date range only, do not apply beginning_of_day or end_of_day within the test file.
- Update the API controller and the test to also scope the returned levels by member. If new fixtures need to be created to test this new functionality, do so.

#### Caching

- Implement Rails caching on MemberDashboard results, keyed on member.id and level.level_type. Expire the cache at the beginning of each day. (keyed instead on `date_scope`, so:)
- Rather than date_scope as a cache_key, key the cache on member.id and level_type

Upon review, all 3 are appropriate:

- Include the date_scope in the cache_key
