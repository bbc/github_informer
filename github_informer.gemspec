Gem::Specification.new do |s|
  s.name        = 'github_informer'
  s.version     = '0.0.3'
  s.date        = '2015-08-06'
  s.summary     = 'Github Informer'
  s.description = 'Publish CI results to Github'
  s.authors     = ['BBC', 'David Buckhurst']
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = [ 'lib/github_informer.rb', 'bin/gh_execute', 'LICENSE', 'README.md' ]
  s.executables = [ "gh_execute" ]
  s.homepage    = 'https://github.com/bbc/github_informer'
  s.license     = 'MIT'
  s.add_runtime_dependency 'octokit'
end
