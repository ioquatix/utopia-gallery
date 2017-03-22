
RSpec.describe Utopia::Gallery::Container do
	let(:pages_root) {File.join(__dir__, 'site/pages')}
	subject{described_class.new(pages_root, 'sample_images')}
	
	it "should list media" do
		expect(subject.count).to be == 4
	end
end
