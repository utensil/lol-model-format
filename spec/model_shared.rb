shared_context "model_shared"  do

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
end