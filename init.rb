require 'redmine'
require 'issue_patch'
require 'hooks'

Redmine::Plugin.register :redmine_issue_merger do
  name 'Redmine Issue Merger plugin'
  author 'Diego Suarez'
  description 'Plugin de mergeado de incidencias para redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  permission :issues_merge, :issues_merge => :merge
end
