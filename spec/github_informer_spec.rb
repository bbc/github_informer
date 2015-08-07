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
      expect( GithubInformer.determine_sha('.').length ).to eq 41
    end

    it "Should raise an error if it can't identify the sha" do
      expect { GithubInformer.determine_sha('/') }.to raise_error
    end
  end

  describe '.normalise_status' do
    it "should normalise :pass as 'success'" do
      expect( GithubInformer.normalise_status(:pass) ).to eq 'success'
    end
    it "should normalise :fail as 'failure'" do
      expect( GithubInformer.normalise_status(:fail) ).to eq 'failure'
    end
    it "should normalise :error as 'error'" do
      expect( GithubInformer.normalise_status(:error) ).to eq 'error'
    end
  end

  describe '.initialize' do
    it "errors if you don't provide a context" do
      expect { GithubInformer.new() }.to raise_error
    end

    it "can be initialized with only a context" do
      expect( GithubInformer.new( :context => 'HiveCI' ) ).to be_a GithubInformer
    end
  end

end

