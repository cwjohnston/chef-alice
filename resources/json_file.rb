actions :create, :delete

attribute :path, :name_attribute => true
attribute :owner, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => 'alice'
attribute :mode, :kind_of => [String, Integer], :default => 0640
attribute :content, :kind_of => Hash

def initialize(*args)
  super
  @action = :create
end
