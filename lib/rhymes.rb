require 'rhymes/version'

module Rhymes
  # generic error
  class RhymesError < RuntimeError; end
  # word does not exist in the dictionary
  class UnknownWord < RhymesError; end
  # dictionary file cannot be found at expected location
  class DictionaryMissing < RhymesError; end

  class << self
    ##
    # Sets up options.
    # - :raw_dict - location of raw dictionary file. Default: /tmp/cmudict.0.7a
    # - :compiled - location to store/retrieve precompiled dictionary. Default: /tmp/rhymes.dat.
    #   Providing location to store precompiled dictionary speeds up consequent loads
    def setup(opts = {})
      opts.each{ |k, v| options[k]  = v }
      yield options if block_given?
      options
    end
    
    ##
    # Return the list of perfect and identical rhymes to provided word (in upper case)
    # raises
    #   Rhymes::UnknownWord       - word does not exist in the dictionary
    #   Rhymes::DictionaryMissing - dictionary file cannot be found at expected location
    def rhyme(word)
      wup = word.upcase
      key = words[wup]
      raise UnknownWord unless key
      rhymes[key] - [wup]
    end

  private
    def options
      @options ||= Struct.new(:raw_dict, :compiled).new('/tmp/cmudict.0.7a', '/tmp/rhymes.dat')
    end

    def words
      init unless @words
      @words 
    end

    def rhymes
      init unless @rhymes
      @rhymes
    end
    
    
    def perfect_key(pron)
      first = pron.rindex{|snd| snd =~ /1$/} || 0
      pron[first..-1]
    end

    def init
      return if load_compiled
      unless File.exists?(options.raw_dict)
        msg = %W[File #{options.raw_dict} does not exist. You can download the latest dictionary
              from https://cmusphinx.svn.sourceforge.net/svnroot/cmusphinx/trunk/cmudict and provide
              file location with Rhymes.setup(:raw_dict => file_full_path) (/tmp/cmudict.0.7a by default)] * ' '
        raise DictionaryMissing.new(msg)
      end
      load_dictionary
    end

    def load_dictionary
      @words, @rhymes = {}, {}
      File.open(options[:raw_dict]) do |f|
        while l = f.gets do
          next if l =~ /^[^A-Z]/
          word, *pron = l.strip.split(' ')
          next if word.empty? || word =~ /\d/
          pron.map!{|snd| snd.sub(/2/, '1')}
          key = perfect_key(pron)
          @words[word] = key
          (@rhymes[key] ||= []) << word
        end
      end
      File.open(options.compiled, 'wb'){|f| f.write(Marshal.dump([@words, @rhymes]))} rescue nil
    end

    def load_compiled
        @words, @rhymes = Marshal.load(File.open(options.compiled, 'rb'){|f| f.read }) if File.exists?(options.compiled)
    end

  end
end
