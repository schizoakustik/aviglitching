#require 'tk'
require 'aviglitch'
require 'streamio-ffmpeg'
require_relative 'lib/glitchingmodule'
include Glitching
Dir.chdir('/home/linus/Videos/glitch/')

#params = {}

# FrameRepeater params
fparams = { :path => '20140120_223646.avi', :last_buffer_frame => 6, :frame_to_repeat => 6, :trailing_frames => 1, :repetitions => 15 }

# Joiner&Mosher params
jparams = { :path => 'gunga01.avi', :other_path => 'gunga01.avi', :frames_to_keep => 65, :all_frames => false }

JoinerAndMosher.new(jparams[:path]).join_and_mosh( jparams ).output "gungeligung.avi"
FrameRepeater.new(fparams[:path]).repeat_frames( fparams ).output "reppetirepp.avi"

#f.transcode
