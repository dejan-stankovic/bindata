#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__)) + '/spec_common'
require 'bindata/registry'

context "The Registry" do
  setup do
    @r = BinData::Registry.instance
  end

  specify "should be a singleton" do
    BinData::Registry.instance.should equal(BinData::Registry.instance)
  end

  specify "should lookup registered names" do
    A = Class.new
    B = Class.new
    @r.register('ASubClass', A)
    @r.register('AnotherSubClass', B)

    @r.lookup('a_sub_class').should eql(A)
    @r.lookup('another_sub_class').should eql(B)
  end

  specify "should not lookup unregistered names" do
    @r.lookup('a_non_existent_sub_class').should be_nil
  end

  specify "should convert CamelCase to underscores" do
    @r.register('CamelCase', A).should eql('camel_case')
  end

  specify "should convert adjacent caps camelCase to underscores" do
    @r.register('XYZCamelCase', A).should eql('xyz_camel_case')
  end

  specify "should ignore the outer nestings of classes" do
    @r.register('A::B::C', A).should eql('c')
  end

  specify "should allow overriding of registered classes" do
    @r.register('A', A)
    @r.register('A', B)

    @r.lookup('a').should eql(B)
  end
end
