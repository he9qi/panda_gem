module Panda
  module Router
    DEFAULT_FORMAT = "json"
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def resource_url
        @url || "/#{self.name.split('::').last.downcase}s"
      end

      def resource_url=(url)
        @url = url
      end

      def match(url)
        self.resource_url = url
      end

      def many_path
        resource_url
      end

      def one_path
        resource_url + "/:id"
      end

      def build_hash_many_path(end_path, relation)
        relation_class_name = relation[0..relation.rindex("_id")-1].capitalize
        prefix_path = Panda::const_get(relation_class_name).resource_url + "/:" + relation
        prefix_path + end_path
      end
      
      def element_url(url, map)
        full_element_url(url.clone.gsub(/:\w+/) { |key| map[key[1..-1].to_sym] || map[key[1..-1].to_s]})
      end

      def full_element_url(url)
        url + ".#{DEFAULT_FORMAT}"
      end

      def clone!
        new_self = self.clone
        new_self.resource_url = self.resource_url
        new_self.connection = self.connection
        new_self
      end
    end

    def element_url_map(url)
      self.class.full_element_url(url.clone.gsub(/:(\w)+/) { |key| @attributes[key[1..-1].to_sym] || @attributes[key[1..-1].to_s]})
    end
  end
end
