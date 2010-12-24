class Parent
  def greeting
    "hello"
  end
end

class Child < Parent
end

child = Child.new
puts child.greeting
Parent = nil
puts child.greeting
