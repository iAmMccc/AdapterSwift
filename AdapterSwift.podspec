#
# Be sure to run `pod lib lint AdapterSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdapterSwift'
  s.version          = '1.0.0'
  s.summary          = 'SwiftUI精细化方案'
  
  s.homepage         = 'https://github.com/intsig171'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mccc' => 'Mccc' }
  s.source           = { :git => 'https://github.com/intsig171/AdapterSwift.git', :tag => s.version.to_s }
  
  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.swift_version         = '5.0'
  
  
  
  s.source_files = 'AdapterSwift/Classes/**/*'
  
  

end
