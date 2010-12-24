class RubyVM
  class <<self
    p self.methods
  end
end
p RubyVM.methods
RubyVM = nil
