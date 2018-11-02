class PersonPreview < Preview
  def initialize(person)
    super(person)
    redefine_associations
  end
end
