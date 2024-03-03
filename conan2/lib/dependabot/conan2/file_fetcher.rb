# typed: true
# frozen_string_literal: true

require "dependabot/file_fetchers"
require "dependabot/file_fetchers/base"

module Dependabot
  module Conan2
    class FileFetcher < Dependabot::FileFetchers::Base
      def self.required_files_message
        "Repo must contain either a conanfile.txt or a conanfile.py"
      end

      def self.required_files_in?(filenames)
        filenames.include?("conanfile.txt")
      end

      sig { override.returns(T::Array[DependencyFile]) }
      def fetch_files
        fetched_files = []
        fetched_files << fetch_file_from_host("conanfile.txt")
        fetched_files.uniq
      end
    end
  end
end

Dependabot::FileFetchers.register("conan2", Dependabot::Conan2::FileFetcher)
