require 'spec_helper'

describe LolModelFormat::SklFile do
    
    #It's time-consuming to load a model, so do it only once
    before :all do
        lambda {
            
            @skl_file_name = File.expand_path('../fixture/Annie/Annie.skl', __FILE__)
            io = File.open(@skl_file_name, 'rb')			
            @skl = SklFile.read(io)
            io.close
        }.should_not raise_error

    end
    
    it 'should read and parse correctly' do
        @skl.should_not be_nil
    end
    
    it 'should has accessible fields' do
        #lambda {
            puts "id: #{@skl.id}"
            puts "version: #{@skl.version}"
            puts "designer_id : #{@skl.designer_id}"
            puts "num_of_bones: #{@skl.num_of_bones.value}"

            @skl.bones.each_with_index do |bone, index|
                puts "bone[#{index}].name: #{bone.name}"
                puts "bone[#{index}].parent_id: #{bone.parent_id}"
                puts "bone[#{index}].scale: #{bone.scale}"
                puts "bone[#{index}].matrix: #{bone.matrix.inspect}"
                puts "bone[#{index}].position: #{bone.position.inspect}"
                puts "bone[#{index}].orientation: #{bone.orientation.inspect}" 
            end

            
            if @skl.version == 2 || @skl.version == 0
              puts "num_of_bone_ids: #{@skl.num_of_bone_ids.value}"
              puts "bone_ids: #{@skl.bone_ids.inspect}"
            end
        #}.should_not raise_error
    end
    
    it 'should be self consistent' do
        @skl.num_of_bones.value.should == @skl.bones.size
    end
    
    it 'should write exactly what it reads' do
        wio = StringIO.new
        @skl.write(wio)
        wio.flush
        wio.seek(0, IO::SEEK_SET)
        
        Digest::MD5.hexdigest(wio.read).should == Digest::MD5.file(@skl_file_name).hexdigest
    end
    
    it 'should be self consistent with version 2' do
        if @skl.version == 2
            @skl.num_of_bone_ids.value.should == @skl.bone_ids.size
        end
    end
    
    it 'should be valid for each field' do
        pending
    end
end