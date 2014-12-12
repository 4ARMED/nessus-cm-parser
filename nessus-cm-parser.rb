#!/usr/bin/env ruby

begin
  require 'nokogiri'
  require 'trollop'
  require 'media_wiki'
rescue LoadError => e
  puts "Missing a gem? Try bundle install: #{e}"
  exit 1
end

@opts = Trollop::options do
  opt :input_file, "Nessus .nessus input file", :type => :string, :required => true
  opt :wiki_url, "MediaWiki API URL (full path to /api.php)", :type => :string, :required => false
  opt :wiki_username, "MediaWiki username", :type => :string, :required => false
  opt :wiki_password, "MediaWiki password", :type => :string, :required => false
  opt :limit, "Limit the number of results processed", :default => 0, :required => false
  opt :verbose, "Be verbose", :default => false
end

def log(message)
  STDERR.puts "[*] #{message}" if @opts[:verbose]
end

if @opts[:wiki_url]
  log "Wiki URL specified, setting up wiki access for #{@opts[:wiki_url]}"
  wiki = MediaWiki::Gateway.new(@opts[:wiki_url])
  if @opts[:wiki_username]
    log "Authenticating with Wiki user #{@opts[:wiki_username]}"
    if @opts[:wiki_password].nil?
      puts "[!] Password not specified"
      exit 1
    end

    begin
      wiki.login(@opts[:wiki_username], @opts[:wiki_password])
    rescue MediaWiki::Unauthorized => e
      puts "[!] Login failed: #{e.to_s}"
    end
  end
end

log "reading nessus file #{@opts[:input_file]}"
xml = Nokogiri::XML(File.new(@opts[:input_file]))

@count = 0

xml.xpath('/NessusClientData_v2/Report').each do |xml_report|
  xml_report.xpath('./ReportHost').each do |xml_host|
    xml_host.xpath('./ReportItem').each do |xml_report_item|
      next unless xml_report_item.attributes['pluginName'].value =~ /Compliance Checks/
      next unless xml_report_item.xpath('./cm:compliance-result', 'cm' => 'http://www.nessus.org/cm').text == "FAILED"

      @text = "[[Category:Findings]]\n[[Category:Compliance]]\n\n"
      @title = xml_report_item.xpath('./cm:compliance-check-name', 'cm' => 'http://www.nessus.org/cm').text.gsub(/^[\d\.]+\s/,'')
      @text << "=Title=\n#{@title}\n\n"
      @text << "=Impact=\nUnknown\n\n"
      @text << "=Exploitability=\nUnknown\n\n"
      @text << "=Description=\n" + xml_report_item.xpath('./cm:compliance-info', 'cm' => 'http://www.nessus.org/cm').text + "\n"
      @text << "=Recommendation=\n" + xml_report_item.xpath('./cm:compliance-solution', 'cm' => 'http://www.nessus.org/cm').text + "\n"
      @text << "=Reference=\n" + xml_report_item.xpath('./cm:compliance-see-also', 'cm' => 'http://www.nessus.org/cm').text + "\n"

      # shove it all in the wiki if configured
      if wiki
        log "creating wiki page: #{@title}"
        begin
          wiki.create(@title, @text)
        rescue MediaWiki::Exception => e
          puts "[!] Exception: #{e.message}"
        end
      else
        puts @text
        puts "---------------"
      end


      @count += 1
      unless @opts[:limit].equal? 0
        break if @count == @opts[:limit]
      end

    end
  end
end
