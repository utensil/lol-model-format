require 'spec_helper'

describe LolModelFormat::LolModel do
    
    include LolModelFormat
    
    it 'should convert to md2 file' do
        ["Annie", "bear", "Akali"].each do |model_name|
                        
            @skl_file_name = File.expand_path("../fixture/#{model_name}.skl", __FILE__)
            File.open(@skl_file_name, 'rb') do |io|
                @skl = SklFile.read(io)
            end
            
            @skn_file_name = File.expand_path("../fixture/#{model_name}.skn", __FILE__)
            File.open(@skn_file_name, 'rb') do |io|
                @skn = SknFile.read(io)
            end			
            
            @animations = {}
            
            ["Attack1"].each do |animation_name|
                anm_file_name = File.expand_path("../fixture/#{model_name}_#{animation_name}.anm", __FILE__)
                
                anm = nil
                
                File.open(anm_file_name, 'rb') do |io|
                    anm = AnmFile.read(io)
                end
                
                @animations[animation_name] = anm
            end
            
            m = LolModel.new @skl, @skn, @animations
            
            md2 = m.to_md2
            
            @md2_file_name = File.expand_path("../fixture/#{model_name}.md2", __FILE__)
            wio = File.open(@md2_file_name, 'wb')	        
            md2.write(wio)
            wio.close        
        end
    end
    
end