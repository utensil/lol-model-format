require 'lol_model_format.rb'

describe LolModelFormat::AnmFile do
	
	include LolModelFormat
	
	context 'dummy' do
		
		it 'should be ok to initilize' do
			AnmFile.new
		end
	end
end