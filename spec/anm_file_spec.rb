require 'spec_helper'

describe LolModelFormat::AnmFile do
    
    #It's time-consuming to load a model, so do it only once
    before :all do
        lambda {
            
            @anm_file_name = File.expand_path('../fixture/Annie/Annie_Attack1.anm', __FILE__)
            io = File.open(@anm_file_name, 'rb')			
            @anm = AnmFile.read(io)
            io.close
        }.should_not raise_error
    end
    
    it 'should read and parse correctly' do
        @anm.should_not be_nil
    end
    
    it 'should has accessible fields' do
        lambda {
            puts "version: #{@anm.version}"
            puts "number_of_bones : #{@anm.number_of_bones.value}"
            puts "number_of_frames: #{@anm.number_of_frames.value}"
            puts "playback_fps: #{@anm.playback_fps}"
            bone = @anm.bones[0]
            puts "bone.name: #{bone.name}"
            puts "bone.flag: #{bone.flag}"
            frame = bone.frames[0]
            orientation = frame.orientation
            position = frame.position
            puts "orientation: #{orientation.x}, #{orientation.y}, #{orientation.z}, #{orientation.w}"
            puts "position: #{position.x}, #{position.y}, #{position.z}"
        }.should_not raise_error
    end
    
    it 'should be self consistent' do
        @anm.number_of_bones.value.should == @anm.bones.size
        @anm.number_of_frames.value.should == @anm.bones[0].frames.size
    end
    
    it 'should write exactly what it reads' do
        wio = StringIO.new
        @anm.write(wio)
        wio.flush
        wio.seek(0, IO::SEEK_SET)
        
        Digest::MD5.hexdigest(wio.read).should == Digest::MD5.file(@anm_file_name).hexdigest
    end
    
    it 'should be valid for each field' do
        pending
    end
end