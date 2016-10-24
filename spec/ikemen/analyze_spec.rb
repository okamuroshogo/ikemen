require 'spec_helper'


describe Morpheme do
  before(:each) { @sample = Morpheme.new(nil) }

  context 'privateメソッドを呼び出す場合' do
    subject { @sample.send(:tweet_replacement,"aaaaaaaa").should == "aaaaaaaa" }
    # Object#sendはレシーバの持っているメソッドを呼び出す
    it { should == true }
  end
end
