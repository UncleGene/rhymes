require 'spec_helper'

describe Rhymes do
  it 'should rhyme ruby with newby and scooby' do
    Rhymes.rhyme('ruby').should include('NEWBY', 'SCOOBY')
    rhymes = Rhymes.new
    rhymes.rhyme('Scooby').should include('NEWBY', 'RUBY')
    rhymes.rhyme('newby').should include('RUBY', 'SCOOBY')
  end

  it 'should rhyme case-insensitive' do
    rhymes = Rhymes.new
    rhymes.rhyme('RubE').should include('CUBE')
    rhymes.rhyme('cUbE').should include('RUBE')
  end

  it 'should raise with unknown word' do
    expect {Rhymes.rhyme('dabadabadaba')}.to raise_error(Rhymes::UnknownWord)
  end

end
