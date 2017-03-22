
RSpec.describe Utopia::Gallery::Cache do
	let(:pages_root) {File.join(__dir__, 'site/pages')}
	let(:cache_root) {File.join(__dir__, 'site/public/_gallery')}
	
	before(:each) do 
		FileUtils.rm_rf cache_root
	end
	
	let(:processes) {[
		Utopia::Gallery::ResizeImage.new(:small, [400, 400], :resize_to_fill),
		Utopia::Gallery::ResizeImage.new(:large, [800, 800], :resize_to_fit),
	]}
	
	let(:container) {Utopia::Gallery::Container.new(pages_root, 'sample_images')}
	
	subject{container.collect{|media| described_class.new(pages_root, cache_root, media, processes)}}
	
	it "should generate thumbnails" do
		subject.each(&:update)
	end
end