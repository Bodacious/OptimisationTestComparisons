# Boot file loads the basic app configs, sets up the databse, etc.

::ROOT_PATH = File.join(File.dirname(__FILE__), "..")

require "database"
require "user"

require "tests"