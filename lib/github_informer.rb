require 'octokit'

class GithubInformer
  
  attr_accessor :params, :repo, :sha, :result

  # Create a new GithubInformer
  # GithubInformer.new( :context => 'HiveCI',
  #                     :url => 'http://hive.local',
  #                     :repo => '/path/to/checkout' )
  def initialize( args = {} )

    ::Octokit.configure do |c|
      c.access_token = args[:github_auth] || ENV['GITHUB_AUTH']
      c.auto_paginate = true
    end

    @params = {}
    @params[:context]    = args[:context] or raise "Requires a context"
    @params[:target_url] = args[:url]
    
    path = args[:repo] || '.'
    @repo = GithubInformer.determine_repo(path)
    @sha  = GithubInformer.determine_sha(path)
  end

  # Report start of job to github
  # ghi.report_start( :description => 'Build job in progress')
  def report_start( args = {} )
    Octokit.create_status( repo, sha, 'pending', params.merge(args) )
  end

  def execute( cmd )
    system( cmd )
    @result = $?.exitstatus
  end

  # Report 
  # ghi.report_end( 0        => [ :pass, 'Build passed successfully'],
  #                 1..100   => [ :fail, 'Build had errors' ],
  #                 :default => [ :error, 'Build totally broken'] )
  def report_end( args = { 0        => [:pass, 'Good to merge'],
                           :default => [:fail, 'Do not merge' ] } )
    if result
      (status,description) = args[:default] || [ :fail, 'Do not merge' ]
      hash = args.select { |a| a === result }
      if !hash.empty?
        (status, description) = hash.values.flatten
      end
      
      status = GithubInformer.normalise_status(status)
      Octokit.create_status( repo, sha, status, params.merge( {:description => description} ) )
    else
      Octokit.create_status( repo, sha, 'error', params.merge( {:description => 'Program never completed'} ) )
    end
  end

  # Make sure the statuses are what the github api expect
  def self.normalise_status(status)
    case
    when status.to_s.match(/fail/)
      'failure'
    when status.to_s.match(/pass/)
      'success'
    else
      status.to_s
    end
  end


  def self.determine_repo(path)
    output = `cd #{path} && git remote -v | grep github`
    res = output.match(/github.com:(.*\/.*).git/)
    repo = res.captures.first
    raise "Couldn't determine repo" if !repo
    repo
  end

  def self.determine_sha(path)
    sha = `cd #{path} && git rev-parse HEAD`.strip
    raise "Couldn't determine sha" if !sha || sha.length == 0
    sha
  end

end
