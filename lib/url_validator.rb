# Validator for URLs
# Docs:
# http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/
# https://github.com/henrik/validates_url_format_of
# http://apidock.com/rails/ActiveModel/Validations/ClassMethods/validates_each#430-Validate-an-optional-URL-field
# http://www.perfectline.ee/blog/building-ruby-on-rails-3-custom-validators
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      valid = URI.parse(value).scheme =~ /https?/
    rescue URI::InvalidURIError
      valid = false
    end
    record.errors[attribute] << "not a valid url" unless valid
  end
end
