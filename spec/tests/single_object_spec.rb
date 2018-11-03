require 'rails_helper'

RSpec.describe "Single object previews" do

  it 'returns model object with new attributes' do
    saved =  Person.create(name: 'Name', age: 25)
    params = { 'name' => 'New Person Name', 'age' => 20 }
    original_attributes = saved.attributes
    preview = saved.preview(params)
    expect(preview).to \
      have_attributes(strip_attributes(original_attributes.merge(params)))
    expect(strip_attributes(saved.reload.attributes)).to \
      eq(strip_attributes(original_attributes))
  end

  it 'does not create or destroy records' do
    saved =  Person.create(name: 'Name', age: 25)
    params = { 'name' => 'New Person Name', 'age' => 20 }
    expect { saved.preview(params) }.not_to change { Person.count }
  end

  def strip_attributes(attrs, to_remove = [])
    to_remove << 'created_at' << 'updated_at'
    to_remove.each { |a| attrs.delete a }
    attrs
  end
end
