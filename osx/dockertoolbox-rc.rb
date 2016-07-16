# Refs:
#  https://github.com/caskroom/homebrew-cask/blob/master/Casks/docker.rb
#  https://github.com/caskroom/homebrew-cask/issues/22281
cask 'dockertoolbox-rc' do
  version 'beta'

  # rc3
  # sha256 '7ac7c061b135f821fac39e53f7b74233dcaf8f926e4c6d28031acc8717b85107'

  # rc4
  # shasum -a 256 Docker.dmg
  sha256 'ebb8b471045defd93b9f100d601b2d1dde4b69cb2465ee12e74976ee00b221d3'
  url "https://download.docker.com/mac/#{version}/Docker.dmg"

  name 'Docker for Mac'
  homepage 'http://www.docker.com/products/docker#/mac'
  license :mit

  auto_updates true

  app 'Docker.app'
end
