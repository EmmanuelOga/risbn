require 'nokogiri'

class RISBN
  module NokogiriUtils
    extend self

    # http://gist.github.com/370755
    def hash_from_node(node)
      { node.root.name.to_sym => xml_node_to_hash(node.root) }
    end

    def xml_node_to_hash(node)
      return to_value(node.content.to_s) unless node.element?

      result_hash = {}

      node.attributes.each do |key, attr|
        ( result_hash[:attributes] ||= Hash.new )[attr.name.to_sym] = to_value(attr.value)
      end

      node.children.each do |child|
        result = xml_node_to_hash(child)

        if child.name == "text"
          return to_value(result) unless child.next_sibling || child.previous_sibling
        else
          key, val = child.name.to_sym, to_value(result)
          result_hash[key] = result_hash.key?(key) ? Array(result_hash[key]).push(val) : val
        end
      end

      result_hash
    end

    def to_value(data)
      data.is_a?(String) && data =~ /^\d+$/ ? data.to_i : data
    end

  end
end
