#require 'tk'
require 'aviglitch'
require 'streamio-ffmpeg'
#require_relative 'lib/framerepeaterclass'
require_relative 'lib/glitchingmodule'

Dir.chdir('/home/linus/Videos/glitch/')

#params = {}
params = { :path => '20140120_223646.avi', :last_buffer_frame => 6, :frame_to_repeat => 6, :trailing_frames => 1, :repetitions => 15 }
f = Glitching::FrameRepeater.new(params[:path])
#f.list_keyframes
#p f.inspect
f.repeat_frames( params )
#f.transcode

#Glitching::Transcode.new(params).transcode
