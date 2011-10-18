require 'spec_helper'

describe Rhymes do
  before(:all) do
    @sample = File.join(File.dirname(__FILE__), 'sample_raw.txt')
    Rhymes.setup(:raw_dict => @sample)
  end
  
  it 'should save provided option' do
    Rhymes.setup(:compiled => '/tmp/sample').should == 
      {:raw_dict => @sample, :compiled => '/tmp/sample'}
  end
  
  it 'should rhyme ruby with newby and scooby' do
    Rhymes.rhyme('ruby').should == ['NEWBY', 'SCOOBY']
    Rhymes.rhyme('Scooby').should == ['NEWBY', 'RUBY']
    Rhymes.rhyme('newby').should == ['RUBY', 'SCOOBY']
  end

  it 'should rhyme rube and cube' do
    Rhymes.rhyme('RubE').should == ['CUBE']
    Rhymes.rhyme('cUbE').should == ['RUBE']
  end

  it 'should rhyme lighter and scriptwriter' do
    Rhymes.rhyme('LIGHTER').should == ['SCRIPTWRITER']
    Rhymes.rhyme('SCRIPTWRITER').should == ['LIGHTER']
  end
  
  it 'should rhyme monterrey and usa' do
    Rhymes.rhyme('MONTERREY').should == ['USA']
    Rhymes.rhyme('USA').should == ['MONTERREY']
  end

  it 'should rhyme nothing with unknown word' do
    Rhymes.rhyme('dabadabadaba').should == []
  end

 end
