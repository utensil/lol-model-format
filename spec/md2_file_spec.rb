require 'spec_helper'

describe LolModelFormat::Ext::Md2File do
    
    include LolModelFormat::Ext
    
    context '1' do

        #It's time-consuming to load a model, so do it only once
        before :all do
            lambda {            
                @md2_file_name = File.expand_path('../fixture/ogro/ogro.md2', __FILE__)
                io = File.open(@md2_file_name, 'rb')			
                @md2 = Md2File.read(io)
                io.close
            }.should_not raise_error
    
        end
        
        it 'should read and parse correctly' do
            @md2.should_not be_nil
        end
        
        it 'should has correct fixed values' do
            @md2.header.ident.should == 844121161
            @md2.header.version.should == 8
        end
        
        it 'should be self consistent' do
            @md2.header.framesize.value.should == @md2.frames[0].num_bytes
            @md2.header.num_skins.value.should == @md2.skin_names.size
            @md2.header.num_vertices.value.should == @md2.frames[0].verts.size
            @md2.header.num_st.value.should == @md2.skin_coords.size
            @md2.header.num_tris.value.should == @md2.triangles.size
            @md2.header.num_glcmds.value.should == @md2.gl_cmds.size
            @md2.header.num_frames.value.should == @md2.frames.size
        end
        
        it 'should be valid for each field' do
            pending
        end
    
    end
    
    context '2' do
        
        before :each do        
           @md2_file_name = File.expand_path('../fixture/ogro/ogro.md2', __FILE__)
        end
    
        it 'should be self consistent when some fields are changed' do
            io = File.open(@md2_file_name, 'rb')	       
            md2_changed = Md2File.read(io)
            
            md2_changed.frames = md2_changed.frames.drop(md2_changed.frames.size / 2)
            md2_changed.skin_names = md2_changed.skin_names.drop(md2_changed.skin_names.size / 2)
            md2_changed.skin_coords = md2_changed.skin_coords.drop(md2_changed.skin_coords.size / 2)
            md2_changed.triangles = md2_changed.triangles.drop(md2_changed.triangles.size / 2)
            md2_changed.gl_cmds = md2_changed.gl_cmds.drop(md2_changed.gl_cmds.size / 2)

            md2_changed.header.framesize.value.should == md2_changed.frames[0].num_bytes
            md2_changed.header.num_skins.value.should == md2_changed.skin_names.size
            md2_changed.header.num_vertices.value.should == md2_changed.frames[0].verts.size
            md2_changed.header.num_st.value.should == md2_changed.skin_coords.size
            md2_changed.header.num_tris.value.should == md2_changed.triangles.size
            md2_changed.header.num_glcmds.value.should == md2_changed.gl_cmds.size
            md2_changed.header.num_frames.value.should == md2_changed.frames.size
            
            wio = File.open("#{@md2_file_name}.drop", 'wb')	        
            md2_changed.write(wio)
            wio.close
        end
        
        it 'should be valid when clean partially' do
            io = File.open(@md2_file_name, 'rb')	       
            md2_changed = Md2File.read(io)
            
            md2_changed.frames = md2_changed.frames.drop(md2_changed.frames.size / 2)
            md2_changed.skin_names = [] 
            md2_changed.skin_coords = []
            md2_changed.triangles = md2_changed.triangles.drop(md2_changed.triangles.size / 2)
            md2_changed.gl_cmds = []

            md2_changed.header.framesize.value.should == md2_changed.frames[0].num_bytes
            md2_changed.header.num_skins.value.should == md2_changed.skin_names.size
            md2_changed.header.num_vertices.value.should == md2_changed.frames[0].verts.size
            md2_changed.header.num_st.value.should == md2_changed.skin_coords.size
            md2_changed.header.num_tris.value.should == md2_changed.triangles.size
            md2_changed.header.num_glcmds.value.should == md2_changed.gl_cmds.size
            md2_changed.header.num_frames.value.should == md2_changed.frames.size
            
            wio = File.open("#{@md2_file_name}.drop", 'wb')	        
            md2_changed.write(wio)
            wio.close
        end
        
        
        it 'should write exactly what it reads' do
            io = File.open(@md2_file_name, 'rb')
            md2 = Md2File.read(io)
            
            wio = StringIO.new
            md2.write(wio)
            wio.flush
            wio.seek(0, IO::SEEK_SET)
            
            Digest::MD5.hexdigest(wio.read).should == Digest::MD5.file(@md2_file_name).hexdigest
        end
        
        it 'should write exactly what it reads when all size fields cleared' do 
            io = File.open(@md2_file_name, 'rb')	       
            md2_changed = Md2File.read(io)
            md2_changed.header.num_skins = 0
            md2_changed.header.num_vertices = 0
            md2_changed.header.num_st = 0
            md2_changed.header.num_tris = 0
            md2_changed.header.num_glcmds = 0
            md2_changed.header.num_frames = 0
            
            md2_changed.header.framesize.value.should == md2_changed.frames[0].num_bytes
            md2_changed.header.num_skins.value.should == md2_changed.skin_names.size
            md2_changed.header.num_vertices.value.should == md2_changed.frames[0].verts.size
            md2_changed.header.num_st.value.should == md2_changed.skin_coords.size
            md2_changed.header.num_tris.value.should == md2_changed.triangles.size
            md2_changed.header.num_glcmds.value.should == md2_changed.gl_cmds.size
            md2_changed.header.num_frames.value.should == md2_changed.frames.size
            
            wio = StringIO.new
            md2_changed.write(wio)
            wio.flush
            wio.seek(0, IO::SEEK_SET)        
            
            Digest::MD5.hexdigest(wio.read).should == Digest::MD5.file(@md2_file_name).hexdigest
        end
    end
    

end