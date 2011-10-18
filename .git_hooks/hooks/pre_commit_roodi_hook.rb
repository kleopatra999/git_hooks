class PreCommitRoodiHook < PreCommitBaseHook
  def run!
    require 'roodi'
    runner = Roodi::Core::Runner.new
    ruby_files.each{ |file| runner.check_file(file) }
    @messages += runner.errors.map(&:to_s)
  rescue LoadError
    @messages << "Roodi is not installed. Please run `gem install roodi`"
  ensure
    true
  end
end
