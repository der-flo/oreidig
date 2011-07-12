class TagsValidator < ActiveModel::Validator
  def validate(record)
    if record.tags_array.present? &&
       !record.tags_array.all? { |tag| tag =~ /^[a-z1-9_!\-]+$/ }
      record.errors[:tags] << 'contains invalid tags'
    end
  end
end
