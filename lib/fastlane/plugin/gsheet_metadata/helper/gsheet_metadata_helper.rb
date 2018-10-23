require 'fastlane_core/ui/ui'
require "google_drive"

module Fastlane
  
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

   # Get output directory
  OUTPUT_DIRECTORY = (File.directory?("fastlane") ? "fastlane/metadata" : "metadata")

  module Helper
    class GsheetMetadataHelper
      # class methods that you define here become available in your action
      # as `Helper::GsheetMetadataHelper.your_method`
      #

      ## This method will ask the name of a spreadsheet and save it
      def self.writeSpreadsheetName(session)
        
        # Ask for name
        input = UI.input("Please write the name of your spreadsheet:")

        # Check if spreadsheet exist
        if !session.spreadsheet_by_title(input)
            UI.error "Spreadsheet not found ! Please retry"
            writeSpreadsheetName(session)
        end

        File.open(OUTPUT_DIRECTORY + "/spreadsheet.txt", "w") { |file|
            file.write(input)
        }
      end

      ## This method will generate all required metadata
      def self.metadata
        
        UI.message "Let's start to generate file for every languages...."

	      # Check first if we have credential to authenticate to Google Drive
        credentials = Dir.glob(OUTPUT_DIRECTORY + "/credentials.json").first

        # If no, we ask the path
        if !credentials
          
          input = UI.input("Please provide the entire path of your credential JSON:")

          File.open(OUTPUT_DIRECTORY + "/credentials.json", "w") { |file|
              file.write(File.read(input))
          }
          credentials = input

        end

        # Authenticate a session with your Service Account
        session = GoogleDrive::Session.from_service_account_key(credentials)

        # Check if there's a spreadsheet name save
        if !File.file?(OUTPUT_DIRECTORY + "/spreadsheet.txt")
            writeSpreadsheetName(session)
        else
          reuse = UI.select("Would you like to use the file '#{File.read(OUTPUT_DIRECTORY + "/spreadsheet.txt")}'?", ["yes (y)", "no (n)"])

          if reuse == "n" || reuse == "no" || reuse == "no (n)"
              writeSpreadsheetName(session)
          end

        end

        # Get spreadsheet by its title
        spreadsheet = session.spreadsheet_by_title(File.read(OUTPUT_DIRECTORY + "/spreadsheet.txt"))

        # Check if spreadsheet exist
        if !spreadsheet
            FileUtils.rm_f(OUTPUT_DIRECTORY + "/spreadsheet.txt")
            UI.error "Spreadsheet not found, please retry"
            exit
        end

        # Enumerate through each sheet
        spreadsheet.worksheets.each { |sheet|
            
            UI.message "Create directory with name " + sheet.title
            
            # Remove directory if exist
            FileUtils.remove_dir(OUTPUT_DIRECTORY + "/" + sheet.title, true)
            
            # Create directory for current sheet
            Dir.mkdir(OUTPUT_DIRECTORY + "/" + sheet.title)
            
            # Enumerate through each title
            sheet.rows[0].each_with_index { |title, index|
                
                # Enumerate through each content
                sheet.rows[1].each_with_index { |content, idx|
                    
                    if idx == index
                        
                        path = OUTPUT_DIRECTORY + "/" + sheet.title + "/" + title + ".txt"
                        
                        # Create a txt file with the title as name
                        File.open(path, "w") { |file|
                            file.write(content)
                        }
                        
                    end
                }
            }
        }
        UI.success "Successfully updated your metadata !"
      end
    end
  end
end