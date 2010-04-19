require 'spec_helper'

describe RISBN do
  it "parses isbn numbers from a line of text" do
    RISBN.parse_first("ISBN-10: 0393317730").to_s.should == "0393317730"
    RISBN.parse_first("ISBN-13: 978-0393317732").to_s.should == "9780393317732"
  end

  it "distinguishes valid and invalid isbns" do
    RISBN.parse_first("ISBN-10: 0393317730").should be_valid
    RISBN.parse_first("ISBN-13: 978-0393317732").should be_valid

    RISBN.parse_first("ISBN-10: 6663317730").should_not be_valid
    RISBN.parse_first("ISBN-13: 666-0393317732").should_not be_valid
  end
end
