# Forked from:
#  https://github.com/caskroom/homebrew-cask/blob/master/Casks/dockertoolbox.rb
# Docs:
#  https://github.com/astorije/homebrew-cask/blob/master/CONTRIBUTING.md#cask-stanzas
cask 'dockertoolbox-rc' do
  version '1.12.0-rc3'

  # shasum -a 256 DockerToolbox-1.12.0-rc3.pkg
  sha256 'e661176aa37223a081ed6bcb82ff94e6c8be15d48075badf4d32c4ddb2ac8cb9'
  # github.com/docker/toolbox was verified as official when first introduced to the cask
  url "https://github.com/docker/toolbox/releases/download/v#{version}/DockerToolbox-#{version}.pkg"

  # appcast URL for an appcast which provides information on future updates
  #  https://github.com/caskroom/homebrew-cask/blob/master/doc/cask_language_reference/stanzas/appcast.md
  #  curl --compressed -L "https://github.com/docker/toolbox/releases.atom" | \
  #    sed 's|<pubDate>[^<]*</pubDate>||g' | shasum -a 256
  appcast 'https://github.com/docker/toolbox/releases.atom',
          checkpoint: '634a681112d156cbcdc75e66508b2a759f70b7e8ce9ff8e8b794338705a8ead7'

  name 'Docker Toolbox'
  homepage 'https://www.docker.com/toolbox'
  license :apache

  pkg "DockerToolbox-#{version}.pkg"

  postflight do
    set_ownership '~/.docker'
  end

  uninstall pkgutil: [
                       'io.boot2dockeriso.pkg.boot2dockeriso',
                       'io.docker.pkg.docker',
                       'io.docker.pkg.dockercompose',
                       'io.docker.pkg.dockermachine',
                       'io.docker.pkg.dockerquickstartterminalapp',
                       'io.docker.pkg.kitematicapp',
                     ]
end
