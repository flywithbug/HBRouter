#
# Be sure to run `pod lib lint HBRouter.podspec' to ensure this is a
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

  s.homepage         = 'https://github.com/flywithbug/HBRouter.git'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'flywithbug' => 'flywithbug@gmail.com' }
  s.source           = { :git => 'https://github.com/flywithbug/HBRouter.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
#  s.static_framework = true

  s.frameworks       = 'UIKit', 'Foundation'

  s.swift_version    = "5.0"
  
  s.subspec 'HBRouter' do |ss|
    ss.source_files = ['HBRouter/Classes/**/*']
  end
  
  
  
  s.ios.deployment_target = "9.0"

end
