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
  s.name             = 'Business_Pod_test'
  s.version          = smart_version
  s.summary          = 'app '


  s.description      = <<-DESC
        app app
                       DESC

  s.homepage         = 'homepage'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'flywithbug' => '' }
  s.source           = { :git => 't', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.static_framework = true

  s.frameworks       = 'UIKit', 'Foundation'


  s.subspec 'Business_Pod_test' do |ss|
    ss.source_files = ['Business_Pod_test/**/*']
  end
  
  
  s.dependency 'HBRouter'
  
  s.ios.deployment_target = "9.0"

end
