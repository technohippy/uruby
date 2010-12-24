class RubyVM
  def self.undef_class
    sleep
    exit
  end
end

class Object
  def self.undef_class
    eval %Q{
      def self.inherited(subclass)
        raise "#{self.name} does not exists."
      end
    }

    self.included_modules.each do |mod|
      (mod.singleton_methods - [:raise]).each do |m|
        undef_method m
      end
    end

    (self.instance_methods - (self.superclass.instance_methods rescue [])).each do |m|
      undef_method m
    end

    undef_method :initialize
    define_method :initialize do
      raise "#{self.name} does not exists."
    end
  end
end

class Mutex
  # call-seq:
  #    mutex.synchronize { ... }
  #
  # Obtains a lock, runs the block, and releases the lock when the
  # block completes.  See the example under Mutex.
  def synchronize
    self.lock
    begin
      yield
    ensure
      self.unlock rescue nil
    end
  end
end

class Thread
  MUTEX_FOR_THREAD_EXCLUSIVE = Mutex.new # :nodoc:

  # call-seq:
  #    Thread.exclusive { block }   => obj
  #  
  # Wraps a block in Thread.critical, restoring the original value
  # upon exit from the critical section, and returns the value of the
  # block.
  def self.exclusive
    MUTEX_FOR_THREAD_EXCLUSIVE.synchronize{
      yield
    }
  end
end
