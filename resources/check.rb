actions :add
default_action :add

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :gem, kind_of: String
attribute :attributes, kind_of: Hash, required: true
