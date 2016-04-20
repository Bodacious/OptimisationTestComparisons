# A simple view class for displaying test results in STDOUT
class View

  # The file path to the ERB template
  VIEW_PATH = File.join(File.dirname(__FILE__), '..', 'views', 'results.txt.erb')

  # The current test
  attr_accessor :test

  # The output string
  attr_reader :output


  def initialize(test)
    @test = test
    @output = ""
  end

  # Render the view template with the current binding. Sets the value of @output
  #
  #
  #
  # Returns a String.
  def render
    ERB.new(File.read(VIEW_PATH), 0, "-", "@output").result(binding)
  end

end