# typed: strict
# frozen_string_literal: true

# These all need to be required so the various classes can be registered in a
# lookup table of package manager names to concrete classes.
require "dependabot/conan2/file_fetcher"
# require "dependabot/conan2/file_parser"
# require "dependabot/conan2/update_checker"
# require "dependabot/conan2/file_updater"
# require "dependabot/conan2/metadata_finder"
# require "dependabot/conan2/requirement"
# require "dependabot/conan2/version"

require "dependabot/pull_request_creator/labeler"
Dependabot::PullRequestCreator::Labeler
  .register_label_details("conan2", name: "java", colour: "ffa221")

require "dependabot/dependency"
Dependabot::Dependency
  .register_production_check("conan2", ->(groups) { groups != ["test"] })

Dependabot::Dependency
  .register_display_name_builder(
    "conan2",
    lambda { |name|
      _group_id, artifact_id = name.split(":")
      name.length <= 100 ? name : artifact_id
    }
  )
