Puppet::Type.type(:rbenvgemsource).provide :default do
  desc "Maintains gem sources inside an RBenv setup"

  commands :su => 'su'

  def add
    args = ['--add']
    args << gem_source

    output = gemsource(*args)
    fail "Could not install: #{output.chomp}" if output.include?('ERROR')
  end

  def remove
    gemsource '--remove', gem_source
  end

  def latest
    @latest ||= list()
  end

  def current
    list
  end

  private
    def gem_source
      resource[:gemsource]
    end

    def gemsource(*args)
      exe =  "RBENV_VERSION=#{resource[:ruby]} " + resource[:rbenv] + '/bin/gem source'
      su('-', resource[:user], '-c', [exe, *args].join(' '))
    end

    def list()
      args = ["--list | egrep -e '^[^\*|\s]'"]

      gemsource(*args).lines.map do |line|
        line =~ /^(?:\S+)\s+\((.+)\)/

        return nil unless $1

        # Fetch the version number
        ver = $1.split(/,\s*/)
        ver.empty? ? nil : ver
      end.first
    end
end
