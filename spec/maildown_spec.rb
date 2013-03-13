require 'spec_helper'

describe 'Maildown' do
  it 'converts via a class method' do
    Maildown.from_html("<b>Test</b>").should == "**Test**"
  end
end
