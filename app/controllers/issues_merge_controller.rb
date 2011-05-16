class IssuesMergeController < ApplicationController
  unloadable

  default_search_scope :issues
  before_filter :find_issues
  before_filter :authorize
  

  def merge
    @issues.sort!{|a,b| a.created_on <=> b.created_on }
    @main_issue = @issues.shift
    @issues.each do |issue|
	@main_issue.mergeWith(issue, User.current)
    end
    flash[:notice] = l("succesfully_merged")
    redirect_to :controller => 'issues', :action => 'index'
  end

end
