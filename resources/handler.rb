actions :add
default_action :add

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :command, kind_of: String, required: true
attribute :type, kind_of: String, required: true
