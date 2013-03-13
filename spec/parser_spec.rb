require 'spec_helper'

describe 'Maildown::Parser' do
  it 'converts simple paragraphs' do
    parser = Maildown::Parser.new(fixture('paragraphs.txt'))
    parser.result.should eq(result_fixture('paragraphs.txt'))
  end

  it 'converts real world html' do
    parser = Maildown::Parser.new(fixture('realworld.txt'))
    parser.result.should eq(result_fixture('realworld.txt'))
  end

  it 'converts real world html' do
    parser = Maildown::Parser.new(fixture('quotes.txt'))
    parser.result.should eq(result_fixture('quotes.txt'))
  end
end
