# typed: false
# frozen_string_literal: true

require "spec_helper"
require "dependabot/conan2/file_fetcher"
require_common_spec "file_fetchers/shared_examples_for_file_fetchers"

RSpec.describe Dependabot::Conan2::FileFetcher do
  it_behaves_like "a dependency file fetcher"

  let(:source) do
    Dependabot::Source.new(
      provider: "github",
      repo: "gocardless/bump",
      directory: directory
    )
  end

  let(:file_fetcher_instance) do
    described_class.new(source: source, credentials: credentials)
  end

  let(:directory) { "/" }
  let(:github_url) { "https://api.github.com/" }
  let(:url) { github_url + "repos/gocardless/bump/contents/" }

  let(:credentials) do
    [{
      "type" => "git_source",
      "host" => "github.com",
      "username" => "x-access-token",
      "password" => "token"
    }]
  end

  describe ".required_files_in?" do
    subject { described_class.required_files_in?(filenames) }

    context "with only a conanfile.txt" do
      let(:filenames) { %w(conanfile.txt) }
      it { is_expected.to eq(true) }
    end

    context "with a non conanfile .txt" do
      let(:filenames) { %w(robot.txt) }
      it { is_expected.to eq(false) }
    end

    context "with a non .txt" do
      let(:filenames) { %w(nonxml.xml) }
      it { is_expected.to eq(false) }
    end

    context "with no files passed" do
      let(:filenames) { %w() }
      it { is_expected.to eq(false) }
    end
  end

  before do
    allow(file_fetcher_instance).to receive(:commit).and_return("sha")
  end

  context "with only a conanfile.txt" do
    before do
      stub_request(:get, File.join(url, "conanfile.txt?ref=sha"))
        .with(headers: { "Authorization" => "token token" })
        .to_return(
          status: 200,
          body: fixture("github", "contents_basic_conanfile_txt.json"),
          headers: { "content-type" => "application/json" }
        )

    end

    it "fetches conanfile.txt" do
      expect(file_fetcher_instance.files.count).to eq(1)
      expect(file_fetcher_instance.files.map(&:name)).to match_array(%w(conanfile.txt))
    end
  end
end
