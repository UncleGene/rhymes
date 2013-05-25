require 'rhymes/version'

class Rhymes
  # word does not exist in the dictionary
  class UnknownWord < RuntimeError; end

  ##
  # Class method (slow, reads data on each call)
  # Returns the list of perfect and identical rhymes to provided word (in upper case)
  # raises
  #   Rhymes::UnknownWord       - word does not exist in the dictionary
  def self.rhyme(word)
    Rhymes.new.rhyme(word)
  end
  
  def initialize
    @words, @rhymes = Marshal.load(File.open(File.expand_path('../data/rhymes.dat', File.dirname(__FILE__)), 'rb'){|f| f.read })
  end

  ##
  # Instance method. Use to front-load the expense of reading data file
  # Returns the list of perfect and identical rhymes to provided word (in upper case)
  # raises
  #   Rhymes::UnknownWord       - word does not exist in the dictionary
  def rhyme(word)
    wup = word.upcase
    key = @words[wup]
    raise UnknownWord unless key
    @rhymes[key] - [wup]
  end
end
