require 'rhymes/version'
# https://cmusphinx.svn.sourceforge.net/svnroot/cmusphinx/trunk/cmudict/
# wget https://cmusphinx.svn.sourceforge.net/svnroot/cmusphinx/trunk/cmudict/cmudict.0.7a

module Rhymes
  DEFAULTS = {:raw_dict => '/tmp/cmudict.0.7a', :compiled => '/tmp/rhymes.dat'}
  
  class << self
    attr_writer :raw_dict
    attr_writer :compied
 
    def setup(options = DEFAULTS)
      @raw_dict = options[:raw_dict] || DEFAULTS[:raw_dict]
      @compiled = options[:compiled] || DEFAULTS[:compiled]
    end

    def rhyme(word)
      wup = word.upcase
      rhymes[words[wup]] - [wup]
    end

  private

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
      if File.exists?(@compiled)
        @words, @rhymes = Marshal.load(File.open(@compiled, 'rb'){|f| f.read })
      elsif File.exists?(@raw_dict)
        @words, @rhymes = {}, {}
        File.open(@raw_dict) do |f| 
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
        begin
          File.open(@compiled, 'wb'){|f| f.write(Marshal.dump([@words, @rhymes]))}
        rescue
          # ????
        end
      else
        raise "File #{@data_dir + RAW} does not exist!"
      end
    end
  end
end


if __FILE__ == $0
  input = ARGV.empty? ? ['laughter', 'soaring', 'antelope'] : ARGV
  input.each{|w| puts "# #{w} - #{Rhymes.rhyme(w).map(&:downcase).join(', ')}"}
end

