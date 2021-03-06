require "rails_helper"

RSpec.describe "Has-many previews" do
  let(:saved_person) { Person.create(name: "Name", age: 25) }
  let(:saved_pet) { Pet.create(name: "Pet Name", person: saved_person) }
  let(:params) do
    {
      "name" => "New Person Name",
      "age" => 20,
      "pets_attributes" => {
        saved_pet.id.to_s => {
          "id" => saved_pet.id,
          "name" => "New Pet Name"
        }
      }
    }
  end
  let(:ignored) { %w(person_id) }

  it "returns model object with new attributes" do
    original_attributes = saved_pet.attributes
    preview = saved_person.preview(params)
    child_attrs = params["pets_attributes"].values.first
    expect(preview.pets.first).to \
      have_attributes(strip_attributes(original_attributes.merge(child_attrs),
                                       ignored))
    expect(strip_attributes(saved_pet.reload.attributes, ignored)).to \
      eq(strip_attributes(original_attributes, ignored))
  end

  it "does not create or destroy records" do
    saved_person
    saved_pet
    expect { saved_person.preview(params) }.not_to change { Person.count }
    expect { saved_person.preview(params) }.not_to change { Pet.count }
  end

  it "loads persisted associated objects when new values aren't given" do
    saved_pet
    preview = saved_person.preview({})
    expect(preview.pets.first.name).to eq(saved_pet.name)
  end

  it "overrides associations after setting a new value" do
    saved_pet
    preview = saved_person.preview({})
    preview.pets = []
    expect(preview.pets).to eq([])
    expect(saved_person.pets).to eq([saved_pet])
  end

  it "properly sets parent preview" do
    saved_pet
    preview = saved_person.preview({ "name" => "PREVIEW"})
    expect(preview.pets.first.person.name).to eq("PREVIEW")
  end

  it "does not generate preview objects for ignored associations" do
    account = Account.create(person: saved_person)
    preview = saved_person.preview({ "name" => "PREVIEW"})
    expect(preview.accounts.first.id).to eq(account.id)
  end

  it "does not generate preview objects for associations without previews" do
    role = Role.create(person: saved_person)
    preview = saved_person.preview({ "name" => "PREVIEW"})
    expect(preview.roles.first.id).to eq(role.id)
  end

  def strip_attributes(attrs, to_remove = [])
    to_remove << "created_at" << "updated_at"
    to_remove.each { |a| attrs.delete a }
    attrs
  end
end
