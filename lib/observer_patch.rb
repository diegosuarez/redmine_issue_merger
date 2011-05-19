require 'dispatcher'
module ObserverPatch
  def self.included(base) # :nodoc:

    base.send(:include, InstanceMethods)
    base.class_eval do 
	cattr_accessor(:disabled)
        alias_method_chain :after_create, :disabled_switch
    end
  end
  
 # module ClassMethods
    
 # end
  
  module InstanceMethods
	def after_create_with_disabled_switch(method_name,*args)
		return if self.class.disabled
		after_create_without_disabled_switch(method_name,*args)
	end
  end    
end

Dispatcher.to_prepare do
   JournalObserver.send(:include, ObserverPatch)
   MessageObserver.send(:include, ObserverPatch)
end
