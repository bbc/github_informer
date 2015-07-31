require 'github_informer'
RSpec.describe GithubInformer do
  describe '.repo' do
    it "Should pick out the github repo from the path" do
      expect( GithubInformer.determine_repo('.') ).to eq 'bbc/github_informer'
    end

    it "Should raise an error if it can't identify the repo" do
      expect { GithubInformer.determine_repo('/') }.to raise_error
    end
  end

  describe '.sha' do
    it "Should pick out the sha from the path" do
      expect( GithubInformer.determine_sha('.') ).to be_a String
      expect( GithubInformer.determine_sha('.').length ).to eq 40
    end

    it "Should raise an error if it can't identify the sha" do
      expect { GithubInformer.determine_sha('/') }.to raise_error
    end
  end

end

