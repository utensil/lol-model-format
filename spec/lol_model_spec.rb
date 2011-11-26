require 'spec_helper'

describe LolModelFormat::LolModel do
    
    include LolModelFormat
    
    it 'should convert to md2 file' do
    	["Annie", "bear", "Akali"].each do |model_name|
    		    		
		    @skl_file_name = File.expand_path("../fixture/#{model_name}.skl", __FILE__)
	        io = File.open(@skl_file_name, 'rb')			
	        @skl = SklFile.read(io)
	        io.close
	        
	        @skn_file_name = File.expand_path("../fixture/#{model_name}.skn", __FILE__)
	        io = File.open(@skn_file_name, 'rb')			
	        @skn = SknFile.read(io)
	        io.close
	        
	        @anm_file_name = File.expand_path("../fixture/#{model_name}_Attack1.anm", __FILE__)
	        io = File.open(@anm_file_name, 'rb')			
	        @anm = AnmFile.read(io)
	        io.close
	    	
	        m = LolModel.new @skl, @skn, @anm
	        
	        md2 = m.to_md2
	        
	        @md2_file_name = File.expand_path("../fixture/#{model_name}.md2", __FILE__)
	        wio = File.open(@md2_file_name, 'wb')	        
	        md2.write(wio)
	        wio.close        
        end
	end
    
end