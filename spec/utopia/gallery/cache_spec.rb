
RSpec.describe Utopia::Gallery::Cache do
	let(:pages_root) {File.join(__dir__, 'site/pages')}
	let(:cache_root) {File.join(__dir__, 'site/public/_gallery')}
	
	before(:each) do 
		FileUtils.rm_rf cache_root
	end
	
	# Cache wants processes as a hash by name.
	let(:processes) do
		{
			small: Utopia::Gallery::ResizeImage.new(:small, [400, 400], :resize_to_fill),
			large: Utopia::Gallery::ResizeImage.new(:large, [800, 800], :resize_to_fit),
		}
	end
	
	let(:container) {Utopia::Gallery::Container.new(pages_root, 'sample_images')}
	
	subject{container.collect{|media| described_class.new(pages_root, cache_root, '/_gallery', media, processes)}}
	let(:output_paths) {subject.collect{|cache| cache.output_paths}.flatten}
	
	it "should generate thumbnails" do
		expect(subject.count).to be == 4
		expect(output_paths.count).to be == 8
		
		subject.each(&:update)
		
		output_paths.each do |output_path|
			expect(File).to be_exist(output_path)
		end
	end
	
	it "it should be reentrant" do
		subject.each(&:update)
		
		expect{subject.each(&:update)}.to_not raise_error
	end
	
	it "can regeneate out of date media" do
		subject.each(&:update)
		
		sleep(1)
		
		subject.each do |cache|
			# Input path becomes newer than output path:
			# Exception: If output_path is a hard link to input_path.
			FileUtils.touch(cache.input_path)
			
			# It should no longer be fresh:
			cache.output_paths.each do |output_path|
				expect(Utopia::Gallery::Process).to_not be_fresh(cache.input_path, output_path)
			end
		end
		
		# Regenerate outputs:
		expect{subject.each(&:update)}.to_not raise_error
		
		# Everything should be fresh:
		subject.each do |cache|
			cache.output_paths.each do |output_path|
				expect(Utopia::Gallery::Process).to be_fresh(cache.input_path, output_path)
			end
		end
	end
end