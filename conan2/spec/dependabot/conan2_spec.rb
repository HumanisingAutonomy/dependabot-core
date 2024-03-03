# typed: false
# frozen_string_literal: true

require "spec_helper"
require "dependabot/conan2"
require_common_spec "shared_examples_for_autoloading"

RSpec.describe Dependabot::Conan2 do
  it_behaves_like "it registers the required classes", "conan2"
end
