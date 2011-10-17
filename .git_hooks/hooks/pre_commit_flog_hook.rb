class PreCommitFlogHook < PreCommitBaseHook
  class Stats
    attr_reader :densities

    def initialize(repo, files)
      @repo, @files = repo, files
      @densities = {}
      @flogger = Flog.new
      scan
    end

    def scan
      @files.each do |file|
        @densities[file] = density_for_file(file)
      end
    end

    def density_for_file(file)
      file_path = File.join(@repo, file)
      return nil unless File.exists?(file_path)
      lines = File.read(file_path).split("\n").reject{|l| l =~ /^\s*(#|$)/}.size
      @flogger.reset
      @flogger.flog(file_path)
      scores = @flogger.total
      scores / lines
    end
  end


  def run!
    require 'flog'

    old_stats = Stats.new(tmp_repo, ruby_files)
    new_stats = Stats.new(repo, ruby_files)
    
    old_stats.densities.each do |file, old_density|
      new_density = new_stats.densities[file]
      if old_density and new_density > old_density
        @messages << "#{file}: density of flog scores is more than it was before: %0.3f VS %0.3f" %
                     [old_density, new_density]
      end
    end
  rescue LoadError
    @messages << "Flog is not installed. Please run `gem install flog`"
  ensure
    return true
  end

  def need_tmp_repo?
    true
  end
end
