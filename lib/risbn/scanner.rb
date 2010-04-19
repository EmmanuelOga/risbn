require 'shellwords'
require 'tmpdir'

class RISBN

  # Scan a file for a isbn. Currently only text files, pdf and chm files are allowed.
  # Uses unix 'file' command to identify the file.
  # For pdf scanning uses poppler, for chm scanning uses archmage.
  module Scanner
    extend self

    # provide a file path of a file to scan for the first found isbn.
    # currently scans pdfs using poppler, chm using archmage and text files.
    # Also, requires the unix utility "file"
    def scan(path)
      case identify(path)
      when /PDF/      then scan_pdf(path)
      when /HtmlHelp/ then scan_chm(path)
      when /text/     then scan_txt(path)
      end || RISBN.new
    end

    def identify(path)
      File.file?(path) ? %x|file -F :::: #{path.to_s.shellescape}|.split("::::").last.strip : ""
    end

    def scan_chm(path)
      Dir.mktmpdir do |dir|
        tmp = File.join(dir, "tempfile.txt")
        system("python -W ignore $(which archmage) -c text #{ path.to_s.shellescape } #{ tmp.to_s.shellescape } 2>&1 > /dev/null")
        scan_txt(tmp)
      end
    end

    def scan_pdf(path)
      Dir.mktmpdir do |dir|
        tmp = File.join(dir, "tempfile.txt")
        system("pdftotext -q -f 0 -l 20 -raw -nopgbrk #{ path.to_s.shellescape } #{ tmp.to_s.shellescape }")
        scan_txt(tmp)
      end
    end

    def scan_txt(path)
      IO.foreach(path) do |line|
        isbn = RISBN.parse_first(line)
        return isbn if isbn.valid?
      end
      nil
    rescue # any problem with the text encoding
      nil
    end

  end
end
