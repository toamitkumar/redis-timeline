class Base
  def initialize(id)
    @id = id
  end
  
  def ==(other)
    @id.to_s == other.id.to_s
  end
  
  attr_reader :id
  
  def self.property(name)
    klass = self.name.downcase
    self.class_eval <<-RUBY
      def #{name}
        _#{name}
      end
      
      def _#{name}
        redis.get("#{klass}:id:" + id.to_s + ":#{name}")
      end
      
      def #{name}=(val)
        redis.set("#{klass}:id:" + id.to_s + ":#{name}", val)
      end
    RUBY
  end
end
