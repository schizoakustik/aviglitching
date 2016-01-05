module GlitchTools

  def list_keyframes
    frame_types = []
    self.frames.each { |frame| frame_types << frame.is_iframe? }
    frame_types.each_with_index { |i, n| puts "#{n} is_iframe" if i }
  end

end