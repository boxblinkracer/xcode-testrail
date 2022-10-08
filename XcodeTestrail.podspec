#
# Be sure to run `pod lib lint xcode-testrail.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XcodeTestrail'
  s.version          = '1.1.0'
  s.summary          = 'TestRail integration for your Xcode tests.'

  s.description      = <<-DESC
A decoupled TestRail integration for your Xcode project to easily send results to TestRail.
                       DESC

  s.homepage         = 'https://github.com/boxblinkracer/xcode-testrail'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christian Dangl' => 'boxblinkracer@gmx.net' }
  s.source           = { :git => 'https://github.com/boxblinkracer/xcode-testrail.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'xcode-testrail/Classes/**/*'


  s.swift_version = [ "5.0" ]

  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }

  s.frameworks = 'XCTest'

end
