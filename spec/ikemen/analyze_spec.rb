require 'spec_helper'


describe Morpheme do
  before(:each) { @mor = Morpheme.new(nil) }

  context '正規表現のテスト　何も起きない' do
    subject { @mor.send(:tweet_replacement,"ぼくは、ごはんを、たべる").should == "ぼくは、ごはんを、たべる" }
    it { should == true }
  end
  context '正規表現のテスト スペース連続' do
    subject { @mor.send(:tweet_replacement,"ぼくは　　ごはんをたべる").should == "ぼくはごはんをたべる" }
    it { should == true }
  end
  context '正規表現のテスト ２回のスペース' do
    subject { @mor.send(:tweet_replacement,"ぼくは　ごはんを　たべる").should == "ぼくはごはんをたべる" }
    it { should == true }
  end
  context '正規表現のテスト 複数回のスペース' do
    subject { @mor.send(:tweet_replacement,"ぼ　く　は　ご　は　ん").should == "ぼくはごはん" }
    it { should == true }
  end
  context '正規表現のテスト tabが含まれる場合' do
    subject { @sample.send(:tweet_replacement,"").should == "" }
    it { should == true }
  end
  context '正規表現のテスト unicodeが含まれる場合' do
    subject { @sample.send(:tweet_replacement,"").should == "" }
    it { should == true }
  end
end

