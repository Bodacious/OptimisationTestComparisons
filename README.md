# Comparing Split A/B Tests VS Epsilon Greedy

This is still a bit of a work in progress, but you should be able to download it and start trying it out yourself.


## Background

The basic idea behind this test was to create a hypothetical optimization test with pre-defined results. I would then take a sample of pre-defined users and feed them through each type of test, to see how the test results compared to the final results (which were defined FIRST in this case.)


### Results so far

From initial testing, it confirms the expectations of Split A/B and Epsilon Greedy tests.

**Split A/B** tests give more objective, accurate results, but more opportunities are _wasted_ on inferior variants.

**Epsilon greedy** tests require much larger sample sizes for accurate results, but far fewer opportunities are _wasted_ on inferior variants.

```
Test: Split test
Sample size: 10000

Expected results:
  Variant A: 5%
  Variant B: 7%

Actual results:
  Variant A: 5.0% 248/4997
  Variant B: 7.0% 348/5003

Test: Epsilon Greedy
Sample size: 10000

Expected results:
  Variant A: 5%
  Variant B: 7%

Actual results:
  Variant A: 5.2% 495/9476
  Variant B: 7.3% 38/524
```

## Prerequisites

1. SQLite3
2. Bundler
3. Ruby 2.3.0 (or remove ruby version from Gemfile)

## Installation

Download the repo

    $ git clone https://github.com/Bodacious/OptmisationTestComparisons.git

Install the gems

    $ bundle install

## Making sure it works

There are a few basic specs in place. Run these with:

    $ rspec spec

## Running the tests

You can run each test with a simple

    $ rake

To run a specific test, use

    $ rake run:split

or

    $ rake run:epsilon_greedy


### Setting the expected final results

By default, the tests will run with an A and B variant, both within the 5%—15% range. To pass in your own variant names, and their expected conversion rates, set the `RESULTS` environment variable, passing in a JSON object with the variants and conversion rates.


    $ rake RESULTS='{"A":9.32,"B":11.65}'


### Setting the number of samples

By default, the tests will run with 5000 samples each test. If you'd like to change this, simply set an env variable like so:

    $ rake run:split SAMPLES=40000

### Setting the exploration rate on Epsilon Greedy tests

The **Epsilon Greedy** test has a random element to it. The algoritm will assign a random variant to the sample user, a small percentage of the time. You can set the rate of randomness with the `RANDOM` environment variable.

    # Run with 1000 samples, and allocate a random variant 20% of the time.
    $ rake run:epsilon_greedy_test SAMPLES=1000 RANDOM=20


## Want to run a test on your website?

[Katana Code](http://katanacode.com/?utm_campaign=OptimisationTestComparisons&utm_source=GitHub&utm_medium=README) is a software development based in Edinburgh Scotland. We work with startups on 4 different continents, helping them design, build, and optimise their digital products.
