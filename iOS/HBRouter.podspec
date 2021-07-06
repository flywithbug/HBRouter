#
# Be sure to run `pod lib lint JYMopedModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

def self.smart_version
   tag = `git describe --abbrev=0 --tags 2>/dev/null`.strip
   if $?.success? then tag else "0.0.1" end
end

Pod::Spec.new do |s|
  s.name             = 'HBRouter'
  s.version          = smart_version
  s.summary          = 'app '


  s.description      = <<-DESC
        app 
                       DESC

  s.homepage         = 'http://gitlab.hellobike.cn/Torrent/HBRouter.git'
  s.license          = 'MIT'
  s.author           = { 'flywithbug' => 'chengerfeng08824@hellobike.com' }
  s.source           = { :git => 'http://gitlab.hellobike.cn/Torrent/HBRouter.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.static_framework = true

  s.frameworks = 'UIKit'

  s.source_files = 'HBRouter/Classes/**/*.{h,m}'
  


end
