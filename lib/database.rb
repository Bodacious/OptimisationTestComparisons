require 'sqlite3'
require 'active_record'

# Set up a SQLite3 database connection...
ActiveRecord::Base.establish_connection({
  charset: 'utf8',
  adapter: "sqlite3",
  database: File.join(ROOT_PATH, 'db', "tests.sqlite3")
})

# Create database schema and load it...
ActiveRecord::Base.connection.instance_eval do

  create_table "users", force: true do |t|
    t.string   "variant", limit: 1, null: false
    t.boolean  "conversion", default: nil
  end

end
