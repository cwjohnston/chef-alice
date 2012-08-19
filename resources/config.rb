actions :create, :updated

def initialize(*args)
  super
  @action = :create
end
