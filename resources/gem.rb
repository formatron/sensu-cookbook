actions :install
default_action :install

attribute :gem, name_attribute: true, kind_of: String, required: true
attribute :version, kind_of: String
