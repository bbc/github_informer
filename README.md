# github_informer

Gem for submitting useful metadata to github to inform pull requests

## Submitting CI information

The GithubInformer CLI lets you submit build and test status information to
github. This is especially useful to help inform on pull requests.

Built and test details are submitted against commit SHAs, so you don't need
to do much, other than point github_informer at the checkout:

    ghinform --fail --repo . --context 'HiveCI Build' 
      --description 'The build failed' --target-url http://hive.local/batch/121
       
