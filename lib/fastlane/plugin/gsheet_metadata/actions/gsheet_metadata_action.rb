require 'fastlane/action'
require_relative '../helper/gsheet_metadata_helper'

module Fastlane
  module Actions
    class GsheetMetadataAction < Action
      def self.run(params)
        Helper::GsheetMetadataHelper.metadata
        UI.message("The gsheet_metadata plugin is working!")
      end

      def self.description
        "Generate metadata from Google Spreadsheet"
      end

      def self.authors
        ["Kevin Morais"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Use a Google Spreadsheet and the plugin will generate txt files for every languages"
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
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
