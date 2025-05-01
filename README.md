# README

## Assumptions

### Data Model

- Incorporate the tz_offset data into the recorded_at DateTime object, but also store it on the table.
- I gave Level a few fields that seem reasonable, assuming future development: type and unit.
- I gave Member an email as a unique identifier.
  
Additional thoughts:

- I'm not implementing login/security that is typical for member / user. This is a _relatively_ solved problem (lots of OOTB or widely adopted convention-based solutions; Devise, et al.), and not asked for in the brief, so I'm assuming that's fine.
- Some indexing could be useful here, especially as complexity and scale grow.
- Back to the `level_type` and `unit` columns. I'm thinking STI could be applied here for different `Level` types, with different behaviors defined. This extension would allow us to move `unit` out of the database and into a constant or definition on the sub-class. Similarly: the upper and lower bounds of target `threshold`s. I may implement parts of this in the cleanup_branch, but I think designing such abstractions with a single usecase in play can limit the direction of future development (see: Sandi Metz's POODR/99 Bottles). Happy to discuss potential strategies further in debrief, though.

### Main functional additions

Provided data isn't great for showing the functionality requested (e.g. `last_7_days` and `month_to_date` scopes both return zero records, as all data points are `tested_at` a 2024 date). Rather than try to adjust this in the app logic, I opted to move all the dates forward to this year (thoughts on why below, and willing to discuss further).

That's still not perfect, as:

- We can't do a prior period comparison, as all "recent" data points occur on the same day. The next most "recent" data points are ~3 months prior, falling outside of both comparison windows.
- The `month_to_date` scope means running calculations on any day prior to the one day (24th) on which "recent" data points fall will result in an empty set of measurements.

I considered writing logic into the seed file to generate more useful data, but as the provided CSV requires an amount of sanitizing and normalizing, I opted to keep the original data. The data hygiene & ingestion work seems like a more useful skill to showcase than generating relatively simple dummy data from scratch.

Instead of writing a 2nd seed file, I wrote test fixtures in such a way that the scopes could be tested usefully.

I haven't applied any styling beyond what rails provides, as this baseline is serviceable for showing the logic at work.

### API and Caching

Copilot didn't seem fully up to date on some newer features from Rails 8 (didn't want to use `.expect` without specific prompting to do so, and flagged it repeatedly on review, for example).

Because of this, I didn't lean too heavily on the whole-cloth code production via prompts in the earlier branches of this project. I still incorporated the assisted auto-completes that provided useful code, such as intuiting the functionality I wanted from `Level`s various scopes based on the name (with some necessary tuning of those results, like `beginning_of_day`/`end_of_day` to meet expectations of the brief).

For the two listed stretch goals (caching and an API endpoint to scope on member / arbitrary date_scope), I wanted to apply this prompt-coding more intentionally. With the foundational elements of the codebase in place, this went much more smoothly, and I didn't end up writing a line of this PR "by hand". Prompts used listed below.

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
