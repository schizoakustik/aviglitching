class Transcode
  include FFMPEG

  attr_accessor :path

  def initialize(params)
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
