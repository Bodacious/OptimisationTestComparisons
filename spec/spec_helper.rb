require "boot"

RSpec.configure do |config|

  config.before :each do
    User.delete_all
  end

end