require 'spec_helper'

describe LolModelFormat::LolModel do
    
    include LolModelFormat
    
    before :all do
        @models = {}
        
        ["Annie"].each do |model_name| #, "bear", "Akali"
                        
            @skl_file_name = File.expand_path("../fixture/#{model_name}/#{model_name}.skl", __FILE__)
            File.open(@skl_file_name, 'rb') do |io|
                @skl = SklFile.read(io)
            end
            
            @skn_file_name = File.expand_path("../fixture/#{model_name}/#{model_name}.skn", __FILE__)
            File.open(@skn_file_name, 'rb') do |io|
                @skn = SknFile.read(io)
            end			
            
            @animations = {}
            
            #
            ["Attack1"].each do |animation_name|
                anm_file_name = File.expand_path("../fixture/#{model_name}/#{model_name}_#{animation_name}.anm", __FILE__)
                
                anm = nil
                
                File.open(anm_file_name, 'rb') do |io|
                    anm = AnmFile.read(io)
                end
                
                @animations[animation_name] = anm
            end
            
            @models[model_name] = LolModel.new @skl, @skn, @animations
        end
    end
    
    it 'should convert to md2 file' do
        @models.each do |model_name, m|         
            md2 = m.to_md2
            
            @md2_file_name = File.expand_path("../generated/#{model_name}.md2", __FILE__)
            wio = File.open(@md2_file_name, 'wb')	        
            md2.write(wio)
            wio.close        
        end
    end

    it 'should convert to dae file' do
        @models.each do |model_name, m|         
            dae = m.to_dae
            
            @dae_file_name = File.expand_path("../generated/#{model_name}.dae", __FILE__)
            wio = File.open(@dae_file_name, 'wb')           
            wio.write(dae)
            wio.close        
        end
    end
    
    it 'should convert to md2 file for skeleton' do
        @models.each do |model_name, m|           
            md2 = m.to_md2_skl            
            @md2_skl_file_name = File.expand_path("../generated/#{model_name}_skl.md2", __FILE__)
            wio = File.open(@md2_skl_file_name, 'wb')        
            md2.write(wio)
            wio.close     
        end
    end
    
end