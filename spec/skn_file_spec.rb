require 'spec_helper'

describe LolModelFormat::SknFile do
    
    include LolModelFormat
    
    #It's time-consuming to load a model, so do it only once
    before :all do
        lambda {
            
            @skn_file_name = File.expand_path('../fixture/Akali.skn', __FILE__)
            io = File.open(@skn_file_name, 'rb')			
            @skn = SknFile.read(io)
            io.close
        }.should_not raise_error

    end
    
    it 'should read and parse correctly' do
        @skn.should_not be_nil
    end
    
    it 'should has accessible fields' do
        lambda {
            puts "version: #{@skn.version}"
            puts "num_of_objects : #{@skn.num_of_objects}"
            puts "num_of_material_headers: #{@skn.num_of_material_headers.value}"
            material_header = @skn.material_headers[0]
            puts "material_header.name: #{material_header.name}"
            puts "material_header.start_vertex: #{material_header.start_vertex}"
            puts "material_header.num_vertices: #{material_header.num_vertices}"
            puts "material_header.start_index: #{material_header.start_index}"
            puts "material_header.num_of_indices: #{material_header.num_of_indices}"
            
            puts "num_of_indices: #{@skn.num_of_indices.value}"
            puts "num_of_vertices: #{@skn.num_of_vertices.value}"
            puts "indices: #{@skn.indices.inspect[0..50]}..."
            
            vertices = @skn.vertices[0]
            puts "vertices: #{vertices.inspect}"
            
            if @skn.version == 2
              puts "end_tab: #{@skn.end_tab.inspect}"
            end
        }.should_not raise_error
    end
    
    it 'should be self consistent' do
        @skn.num_of_objects.value.should == @skn.material_headers.size
    end
    
    it 'should write exactly what it reads' do
        wio = StringIO.new
        @skn.write(wio)
        wio.flush
        wio.seek(0, IO::SEEK_SET)
        
        Digest::MD5.hexdigest(wio.read).should == Digest::MD5.file(@skn_file_name).hexdigest
    end
    
    it 'should be valid for each field' do
        pending
    end
end