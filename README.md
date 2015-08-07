# github_informer

Gem for submitting useful metadata to github to inform pull requests

## Submitting CI information

GithubInformer lets you wrap execution of your test or build scripts with github
hooks to let you add CI status check information to your commits. These status
checks appear alongside your pull request discussion in github and help with the
conversation.

### Authentication

github_informer uses OAuth access tokens to manage access. You should set the 
```GITHUB_AUTH``` environment variable to make the auth token available to the 
gem.

### Using the CLI

The CLI is the easiest method of capturing your status checks. Simply install
the gem and wrap your ci commands like this example:

    gh_execute --cmd 'bundle exec rspec'

You can add a context to the execution so it's more identifiable in github:

    gh_execute --context 'Rspec tests' --cmd 'bundle exec rspec'

There are numerous optional arguments for more control:

    gh_execute --cmd 'bundle exec rspec'
              [--context <CONTEXT>]
              [--path <PATH_TO_CHECKOUT>]
              [--url <URL_LINK_TO_CI_JOB>]

If you're running in jenkins, url will automatically get picked up by the
environment.

### Using the API

You can have much more control over the messages that get reported into github
if you write a ruby script to wrap your execution. For example, the following
script gives comprehensive failure messages:

    # Create new informer
    g = GithubInformer.new(:context => 'HiveCI', :url => ENV['HIVE_JOB_URL'] )

    # Add a pending status check to github
    g.report_start( :description => 'Executing unit tests in Hive environment')

    # Wrap execution of the script
    g.execute( 'bundle exec rake unittests' )

    # Report a different message depending on the exit value of the script
    g.report_end( 0      => [:pass, 'Unit tests were fine: good to merge'],
                  1      => [:pending, 'Tests are re-running. Hold off merge.'],
                  2..200 => [:fail, 'Unit test failure. Do not merge'] )

## License

GithubInformer is available to everyone under the terms of the MIT open source licence. 
Take a look at the LICENSE file in the code.

Copyright (c) 2015 BBC
