$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__)) unless $LOAD_PATH.include?(File.expand_path('../../lib', __FILE__))
require File.expand_path('../../lib/lol_model_format', __FILE__)

include LolModelFormat
include LolModelFormat::Ext

skn_file_name = File.expand_path('../../spec/fixture/Akali.skn', __FILE__)
File.open("#{skn_file_name}.trace", 'w') do |wio|
    BinData::trace_reading wio do
        File.open(skn_file_name, 'rb') do |io|
            SknFile.read(io)
        end
    end
end

skl_file_name = File.expand_path('../../spec/fixture/Akali.skl', __FILE__)
File.open("#{skl_file_name}.trace", 'w') do |wio|
    BinData::trace_reading wio do
        File.open(skl_file_name, 'rb') do |io|
            SklFile.read(io)
        end
    end
end

anm_file_name = File.expand_path('../../spec/fixture/Akali_Attack1.anm', __FILE__)
File.open("#{anm_file_name}.trace", 'w') do |wio|
    BinData::trace_reading wio do
        File.open(anm_file_name, 'rb') do |io|
            AnmFile.read(io)
        end
    end
end

md2_file_name = File.expand_path('../../spec/fixture/ogro.md2', __FILE__)
File.open("#{md2_file_name}.trace", 'w') do |wio|
    BinData::trace_reading wio do
        File.open(md2_file_name, 'rb') do |io|
            Md2File.read(io)
        end
    end
end
