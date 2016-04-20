# Comparing Split A/B Tests VS Epsilon Greedy

This is still a bit of a work in progress, but you should be able to download it and start trying it out yourself.


## Background

The basic idea behind this test was to create a hypothetical optimization test with pre-defined results. I would then take a sample of pre-defined users and feed them through each type of test, to see how the test results compared to the final results (which were defined FIRST in this case.)


### Results so far

From initial testing, it confirms the expectations of Split A/B and Epsilon Greedy tests.

**Split A/B** tests give more objective, accurate results, but more opportunities are _wasted_ on inferior variants.

**Epsilon greedy** tests require much larger sample sizes for accurate results, but far fewer opportunities are _wasted_ on inferior variants.

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

### Setting the number of samples

By default, the tests will run with 5000 samples each test. If you'd like to change this, simply set an env variable like so:

    $ rake run:split SAMPLES=40000

### Setting the exploration rate on Epsilon Greedy tests

The **Epsilon Greedy** test has a random element to it. The algoritm will assign a random variant to the sample user, a small percentage of the time. You can set the rate of randomness with the `RANDOM` environment variable.

    # Run with 1000 samples, and allocate a random variant 20% of the time.
    $ rake run:epsilon_greedy_test SAMPLES=1000 RANDOM=20
