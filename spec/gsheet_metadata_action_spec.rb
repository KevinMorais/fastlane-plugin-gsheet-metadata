describe Fastlane::Actions::GsheetMetadataAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The gsheet_metadata plugin is working!")

      Fastlane::Actions::GsheetMetadataAction.run(nil)
    end
  end
end
