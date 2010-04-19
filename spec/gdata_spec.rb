require 'spec_helper'

describe RISBN::GData do
  it "can create a gdata instance from a string" do
    RISBN::GData("9780596101992").should be_an_instance_of(RISBN::GData)
  end

  it "can create a gdata instance from a RISBN" do
    RISBN("9780596101992").gdata.should be_an_instance_of(RISBN::GData)
    RISBN::GData(RISBN("9780596101992")).should be_an_instance_of(RISBN::GData)
  end

  it "raises Invalid ISBN if apropriate" do
    expect { RISBN::GData("6660596101992")        }.to raise_exception(RISBN::InvalidISBN)
    expect { RISBN("6660596101992").gdata         }.to raise_exception(RISBN::InvalidISBN)
    expect { RISBN::GData(RISBN("6660596101992")) }.to raise_exception(RISBN::InvalidISBN)
  end

  context "#data" do
    let(:isbn) { RISBN("9780596101992") }
    before     { isbn.gdata.stub!(:xml).and_return(FIXTURE["book.xml"]) }

    let(:required_keys) do
      more = [:open_access, :rating_max, :rating_min, :thumbnail_url,
              :info_url, :annotation_url, :alternate_url, :self_url]
      isbn.gdata.to_hash.keys.uniq - [:link, :openAccess] + more
    end

    subject { isbn.gdata.data }
    it { should be_an_instance_of(RISBN::GData::BookData) }

    it "maps the attributes of the hash form of the google response to an struct" do
      required_keys.each { |key| should respond_to(key) }
    end

    it "is able to convert the struct to a hash and return its keys" do
      isbn.gdata.data.to_hash.should  be_an_instance_of(Hash)
      isbn.gdata.data.keys.should     be_an_instance_of(Array)
      isbn.gdata.data.keys.should_not be_empty
    end
  end

  context "specific cases" do
    context "0072253592" do
      let(:isbn) { RISBN("0072253592") }
      before     { isbn.gdata.stub!(:xml).and_return(FIXTURE["#{isbn.to_s}.xml"]) }
      subject    { isbn.gdata.data }
      it         { should be_an_instance_of(RISBN::GData::BookData) }
    end
  end
end
