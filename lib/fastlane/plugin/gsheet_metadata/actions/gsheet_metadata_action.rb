require 'fastlane/action'
require_relative '../helper/gsheet_metadata_helper'

module Fastlane
  module Actions
    class GsheetMetadataAction < Action
      def self.run(params)
        Helper::GsheetMetadataHelper.run
        #UI.message("The gsheet_metadata plugin is working!")
      end

      def self.description
        "Generate metadata from a Google Spreadhseet"
      end

      def self.authors
        ["Kevin Morais"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "This plugin will generate all required metadata from a Google Spreadsheet. . Every sheet represent a language"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "GSHEET_METADATA_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
