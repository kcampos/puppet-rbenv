Puppet::Type.newtype(:rbenvgemsource) do
  desc 'A Gem source installed inside an rbenv-installed Ruby'

  ensurable do
    newvalue(:present) { provider.add   }
    newvalue(:absent ) { provider.remove }

    newvalue(:latest) {
      provider.remove if provider.current
      provider.add
    }

    newvalue(/./)  do
      provider.uninstall if provider.current
      provider.add
    end

    aliasvalue :installed, :present

    defaultto :present

    def retrieve
      provider.current || :absent
    end

    def insync?(current)
      requested = @should.first

      case requested
      when :present, :installed
        current != :absent
      when :latest
        current == provider.latest
      when :absent
        current == :absent
      else
        current == [requested]
      end
    end
  end

  newparam(:name) do
    desc 'Gem source qualified name within an rbenv repository'
  end

  newparam(:gemsource) do
    desc 'The Gem source'
  end

  newparam(:ruby) do
    desc 'The ruby interpreter version'
  end

  newparam(:rbenv) do
    desc 'The rbenv root'
  end

  newparam(:user) do
    desc 'The rbenv owner'
  end

end
