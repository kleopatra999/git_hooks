class PreCommitSaikuroHook < PreCommitBaseHook
  def run!
    unless saikuro_installed?
      messages << "Saikuro is not installed. To install it run `gem install saikuro`"
      return true
    end
    require 'nokogiri'

    system saikuro_command
    parse_html
  rescue LoadError
    messages << "Saikuro hook requires nokogiri. To install it run `gem install nokogiri`"
  ensure
    FileUtils.rm_rf output_dir
    true
  end

  def saikuro_command
    parse_files = ruby_files.map{|f| "-p #{f}"}
    "saikuro -o #{output_dir} -c #{parse_files} > /dev/null"
  end

  def output_dir
    File.join(Dir.tmpdir, "git_hook_saikuro")
  end

  def saikuro_installed?
    system "which saikuro > /dev/null"
  end

  def index_html
    File.join(output_dir, "index_cyclo.html")
  end

  def format_message(msg)
    "Saikuro #{msg}"
  end

  def parse_html
    html = File.read(index_html)
    doc = Nokogiri::HTML(html)
    doc.css('html > body > table > tr').each do |tr|
      tds = tr.css('td')
      if a = tds.children.first
         file       = a['href'].gsub(/_cyclo\.html$/, '')
         klass      = a.text
         method     = tds[1].text
         complexity = tds[2].text
         type       = tds[2]['class']
         messages << "#{type}: #{file}: #{klass}##{method} has complexity #{complexity}"
      end
    end
  end
end
