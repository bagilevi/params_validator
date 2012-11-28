require 'spec_helper'

describe ParamsValidator::InvalidParamsException do
  it 'should create a message from simple errors' do
    e = ParamsValidator::InvalidParamsException.new
    e.errors = { :x => 'is missing', :y => 'is not of type hash'}
    e.message.should == "x is missing, y is not of type hash"
  end

  it 'should create a message from errors from nested params' do
    e = ParamsValidator::InvalidParamsException.new
    e.errors = { [:user, :name, :first_name] => 'is missing', :y => 'is not of type hash'}
    e.message.should == "user.name.first_name is missing, y is not of type hash"
  end
end
