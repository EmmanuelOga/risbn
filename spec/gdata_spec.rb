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

  context "retrieving gdata" do
    before do
      @isbn = RISBN("9780596101992")
      @isbn.gdata.stub!(:xml).and_return(File.read(GDATA_FIXTURE_PATH))
    end

    it "returns an OpenStruct" do
      @isbn.gdata.data.should be_an_instance_of(OpenStruct)
    end

    it "maps the attributes of the hash form of google response to an struct" do
      additional_keys = [:open_access, :rating_max, :rating_min, :thumbnail_url,
        :info_url, :annotation_url, :alternate_url, :self_url]

      ( @isbn.gdata.to_hash.keys.uniq - [:link, :openAccess] + additional_keys).each do |key|
        @isbn.gdata.data.should respond_to(key)
      end
    end
  end
end
