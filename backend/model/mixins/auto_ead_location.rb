module AutoEADLocation
  def self.included(base)
    base.extend(ClassMethods)
  end

  def update_from_json(json, extra_values = {}, apply_nested_records = true)
    obj = super
    obj.ead_location = Resource.build_ead_location(obj)
    obj.save
    obj
  end

  module ClassMethods
    def build_ead_location(obj)
      begin
        parts = []
        parts << AppConfig[:public_proxy_url]
        if obj.slug
          if AppConfig[:repo_name_in_slugs]
            repo = Repository.first(id: obj.repo_id)
            repo_slug = repo && repo.slug ? repo.slug : nil
          end
          parts.concat([repo_slug, 'resources', obj.slug].compact)
        else
          parts.concat(
            [
              'repositories',
              obj.repo_id.to_s,
              'resources',
              obj.id.to_s
            ]
          )
        end
        File.join(*parts)
      rescue StandardError => ex
        $stderr.puts "Error building EAD Location: #{ex.message}\n#{obj.inspect}"
        nil
      end
    end

    def create_from_json(json, extra_values = {})
      obj = super
      obj.ead_location = Resource.build_ead_location(obj)
      obj.save
      obj
    end
  end
end
