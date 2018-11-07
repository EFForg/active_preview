class PersonPreview < ActivePreview::Preview
  def ignored_associations
    %w(accounts).freeze
  end
end
