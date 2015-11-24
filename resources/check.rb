actions :add
default_action :add

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :command, kind_of: String, required: true
attribute :interval, kind_of: Fixnum, required: true
attribute :subscribers, kind_of: Array, required: true
