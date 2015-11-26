actions :add
default_action :add

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :type, kind_of: String, required: true
attribute :output_type, kind_of: String, required: true
attribute :auto_tag_host, kind_of: [TrueClass, FalseClass], required: true
attribute :command, kind_of: String, required: true
attribute :interval, kind_of: Fixnum, required: true
attribute :subscribers, kind_of: Array, required: true
attribute :handlers, kind_of: Array, required: true
