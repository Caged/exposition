require 'helper'

context "Parsing Classes and Categories in Header Files" do
  setup do
    @parser = ObjCObjectsParser.new
  end
  
  test 'parses objc class' do
    c1 = parse_file("SampleClass")
    assert_instance_of(ObjCClasses::ObjCClass, c1)
    
    assert_equal('SampleClass', c1.name)
    assert_equal('NSObject', c1.superclass)
    
    assert_not_nil(c1.properties)
    assert_not_nil(c1.class_methods)
    assert_not_nil(c1.instance_methods)
    
    doc_str = "This is some documentation for SampleClass."
    assert_equal(doc_str, c1.documentation.summary[0, doc_str.length])
  end
end