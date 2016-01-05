require 'streamio-ffmpeg'
require 'aviglitch'
require_relative 'glitchingmodule'
include Glitching
Dir.chdir('C:\Users\9 of Spades\Videos\EGET\schizoakustik\Glitch')
params = { :path => "79LBqv57xvH1nqlN.avi", :last_buffer_frame => 6, :frame_to_repeat => 6, :trailing_frames => 1, :repetitions => 15 }
#NonAvi.new(params).transcode
a = Avi.new(params[:path])
Avi.new( params[:path] ).repeat_frames( params )