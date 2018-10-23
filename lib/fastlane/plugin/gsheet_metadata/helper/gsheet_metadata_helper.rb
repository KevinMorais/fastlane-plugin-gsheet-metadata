require 'fastlane_core/ui/ui'
require "google_drive"

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
      def self.metadata
        
        UI.message "Let's start to generate file for every languages...."

        # Get output directory
        output_directory = (File.directory?("fastlane") ? "fastlane/metadata" : "metadata")

	      # Check first if we have credential to authenticate to Google Drive
        credentials = Dir.glob(output_directory + "*.json").first
        
        UI.message "ouput directory: " + output_directory

        # If no, we ask the path
        if !credentials
          
          input = UI.input("Please provide the entire path of your credential JSON:")

          File.open(output_directory + "/credentials.json", "w") { |file|
              file.write(File.read(input))
          }
          credentials = input

        end

        # Authenticate a session with your Service Account
        session = GoogleDrive::Session.from_service_account_key(credentials)

        # Check if there's a spreadsheet name save
        if !File.file?(output_directory + "/spreadsheet.txt")

            # Ask for name
            input = UI.input("Please write the name of your spreadsheet:")

            # Check if spreadsheet exist
            if !session.spreadsheet_by_title(input)
                UI.error "Spreadsheet not found ! Please retry"
                exit
            end

            File.open(output_directory + "/spreadsheet.txt", "w") { |file|
                file.write(input)
            }

        end

        # Get spreadsheet by its title
        spreadsheet = session.spreadsheet_by_title(File.read(output_directory + "/spreadsheet.txt"))

        # Check if spreadsheet exist
        if !spreadsheet
            FileUtils.rm_f(output_directory + "/spreadsheet.txt")
            UI.error "Spreadsheet not found, please retry"
            exit
        end

        # Enumerate through each sheet
        spreadsheet.worksheets.each { |sheet|
            
            UI.message "Create directory with name " + sheet.title
            
            # Remove directory if exist
            FileUtils.remove_dir(output_directory + "/" + sheet.title, true)
            
            # Create directory for current sheet
            Dir.mkdir(output_directory + "/" + sheet.title)
            
            # Enumerate through each title
            sheet.rows[0].each_with_index { |title, index|
                
                # Enumerate through each content
                sheet.rows[1].each_with_index { |content, idx|
                    
                    if idx == index
                        
                        path = output_directory + "/" + sheet.title + "/" + title + ".txt"
                        
                        # Create a txt file with the title as name
                        File.open(path, "w") { |file|
                            file.write(content)
                        }
                        
                    end
                }
            }
        }

        UI.success "You can now retrieve all of your files in root of this directory"
      end
    end
  end
end