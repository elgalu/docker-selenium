# Docs:
#  https://github.com/astorije/homebrew-cask/blob/master/CONTRIBUTING.md#cask-stanzas
cask 'vnc_cask' do
  version '5.3.2'

  # shasum -a 256 VNC-5.3.2-MacOSX-x86_64.pkg
  sha256 'ed075ad1bec0d3d6ae9c446fbdec211798853d79f14c7a98520819f22fe991d3'
  url "https://www.realvnc.com/download/file/vnc.files/VNC-#{version}-MacOSX-x86_64.pkg"

  name 'RealVNC Viewer'
  homepage 'https://www.realvnc.com'

  pkg "VNC-#{version}-MacOSX-x86_64.pkg"
end
