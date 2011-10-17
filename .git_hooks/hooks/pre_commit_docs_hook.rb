class PreCommitDocsHook < PreCommitBaseHook
  GAUGES = :modules, :classes, :methods, :constants,  :coverage
  
  class Stats
    attr_accessor *GAUGES
    def initialize(yard_output)
      yard_output.split("\n").each do |line|
        case line
        when /(Modules|Classes|Methods|Constants).*\(\s*(\d+) undocumented/
          send "#{$1.downcase}=", $2.to_i
        when /(.*)% documented/
          @coverage = $1.to_f
        end
      end
    end
  end


  def run!
    unless yard_installed?
      messages << "Yard is not installed. To install it run `gem install yard`"
      return true
    end

    old_stats = repo_stats(tmp_repo)
    new_stats = repo_stats(repo)

    GAUGES.each do |entity|
      case entity
        when :coverage
          messages << "You decline documentation coverage. #{new_stats.coverage}% against #{old_stats.coverage}%" if old_stats.coverage > new_stats.coverage
        else
          removed_docs = new_stats.send(entity) - old_stats.send(entity)
          messages << "You removed documentation for #{removed_docs} #{entity}" if removed_docs > 0
      end
    end

    return true
  end

  def repo_stats(repo_path)
    output = %x(cd #{repo_path} && #{yard_command})
    Stats.new(output)
  end

  def yard_command
    "yard --query \"#{yard_query}\""
  end

  def yard_query 
    file_list = ruby_files.map{|f| "'#{f}'"}.join(', ')
    "[#{file_list}].include? object.file"
  end

  def yard_installed?
    system "which yard > /dev/null"
  end

  def need_tmp_repo?
    true
  end
end
