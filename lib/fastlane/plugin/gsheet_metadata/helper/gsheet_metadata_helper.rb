require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GsheetMetadataHelper
      # class methods that you define here become available in your action
      # as `Helper::GsheetMetadataHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the gsheet_metadata plugin helper!")
      end
      def self.run
        GSheetMetadata::GSheetMetadata.generate?
      end
    end
  end
end
