require 'spec_helper'

describe LolModelFormat::SklFile do
    
    include LolModelFormat
    
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
            puts "version: #{@skl.version}"
            puts "designer_id : #{@skl.designer_id}"
            puts "num_of_bones: #{@skl.num_of_bones.value}"
            bone = @skl.bones[0]
            puts "bone.name: #{bone.name}"
            puts "bone.parent_id: #{bone.parent_id}"
            puts "bone.scale: #{bone.scale}"
            puts "bone.matrix: #{bone.matrix.inspect}"
            puts "bone.position: #{bone.position.inspect}"
            puts "bone.orientation: #{bone.orientation.inspect}"
            
            if @skl.version == 2
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