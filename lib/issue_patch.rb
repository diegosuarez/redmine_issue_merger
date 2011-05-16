require_dependency 'issue'

# Patches Redmine's Issues dynamically.  Adds a relationship 
# Issue +belongs_to+ to Deliverable
module IssuePatch
  def self.included(base) # :nodoc:
#    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
    end
end
  
 # module ClassMethods
    
 # end
  
  module InstanceMethods
    # Unimos dos incidencias. La implicita pasa a formar parte de la pasada como parametro.
    # Estaria bien crear un nuevo tipo de estado (merged) como IssueStatus, pero por el momento nos apanhamos con "rechazada" (status_id=6)
    def mergeWith(anotherIssue, merged_by)
	self.status_id = 6 # Marcamos la incidencia como rechazada (tipo 6)
	relationship = IssueRelation.new( :issue_from=> self, :issue_to=>anotherIssue, :relation_type=>IssueRelation::TYPE_DUPLICATES)
	relationship.save!
	anotherIssue.journals << Journal.new( :journalized=>anotherIssue, :user=> merged_by, :notes=>l("from_issue_number"+self.id.to_s+":\n"+self.description )
	anotherIssue.journals << self.journals
	anotherIssue.watcher_users << self.watcher_users
	anotherIssue.watcher_users << self.assigned_to if self.assigned_to
	anotherIssue.attachments << self.attachments
	#JournalObserver 
	self.journals << Journal.new( :journalized=>self, :user=> merged_by, :notes=>l("issue_merged_with")+anotherIssue.id.to_s )
	anotherIssue.save!
	self.save!
    end
  end    
end

# Add module to Issue
Issue.send(:include, IssuePatch)
