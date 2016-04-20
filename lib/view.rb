class View

  VIEW_PATH = File.join(File.dirname(__FILE__), '..', 'views', 'results.txt.erb')


  attr_accessor :test

  attr_reader :output

  def initialize(test)
    @test = test
    @output = ""
  end

  def render
    ERB.new(File.read(VIEW_PATH), 0, "-", "@output").result(binding)
  end

end