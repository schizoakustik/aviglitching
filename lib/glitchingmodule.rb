module Glitching
  
  class NonAvi < FFMPEG::Movie
    include FFMPEG
    attr_accessor :path

    def initialize params
      @path = params[:path]
    end

    def transcode
      outfile = File.basename(self.path, '.*')
      m = Movie.new(self.path)
      unless File.exist?(outfile + '.avi')
        m.transcode(outfile + '.avi') {|progress| puts progress}
        puts "#{outfile}.avi saved."
      else
        puts 'file already has existence.'
      end
    end

  end

  class FrameRepeater < AviGlitch::Base
    attr_accessor :path, :last_buffer_frame, :frame_to_repeat, :trailing_frames, :repetitions

    def repeat_frames params
      @path = params[:path]
      @last_buffer_frame = params[:last_buffer_frame]
      @frame_to_repeat = params[:frame_to_repeat]
      @trailing_frames = params[:trailing_frames]
      @repetitions = params[:repetitions]
      # Get rid of file ext for later
      filename = File.basename(@path, '.*')
      # Get the last frame
      last_frame = self.frames.size
      # Put all non-keyframes in d
      d = []
      self.frames.each_with_index { |f, i| d.push(i) if f.is_deltaframe? }
      # Keep frames up until last_buffer_frame
      q = self.frames[0, @last_buffer_frame]            # TODO a similar construct as below i.e. self.frames[0, @lbf].to_avi.frames.concat ... ?
      # Add frame_to_repeat and any trailing_frames to x
      x = self.frames[d[@frame_to_repeat], @trailing_frames]
      # Repeat frames repetitions times and add to q
      q.concat(x * @repetitions)
      # Add the rest of the frames to y and stick it to the end of q
      y = self.frames[d[@last_buffer_frame + 1], last_frame]
      q.concat(y)
      # New AviGlitch instance with the glitched file
      o = AviGlitch.open(q)
      # Return glitched instance to the program
      return o
      #o.output "#{filename}_#{@last_buffer_frame}_((#{@frame_to_repeat}-#{@trailing_frames})x#{@repetitions}).avi"
    end
  end

  class JoinerAndMosher < AviGlitch::Base
    attr_accessor :path, :other_path, :all_frames

    def join_and_mosh params
      @path = params[:path]
      @other_path = AviGlitch.open(params[:other_path])
      @frames_to_keep = params[:frames_to_keep]
      @all_frames = params[:all_frames]
      
      unless all_frames 
        o = AviGlitch.open(self.frames[0, @frames_to_keep].to_avi.frames.concat(@other_path.frames.to_avi.remove_all_keyframes!.frames))
      else
        o = AviGlitch.open(self.frames.concat(@other_path.frames.to_avi.remove_all_keyframes!.frames))
      end
        return o
        #o.output "#{@path}_#{params[:other_path]}_mosh.avi"
    end

  end

    def list_keyframes
      frame_types = []
      self.frames.each { |frame| frame_types << frame.is_iframe? }
      frame_types.each_with_index { |i, n| puts "#{n} is_iframe" if i }
    end

end