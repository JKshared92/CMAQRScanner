#
# Be sure to run `pod lib lint CMAQRScanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CMAQRScanner'
  s.version          = '0.1.0'
  s.summary          = '二维码扫描器'

  s.homepage         = 'https://github.com/JKshared92/CMAQRScanner'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'comma' => '506702341@qq.com' }
  s.source           = { :git => 'https://github.com/JKshared92/CMAQRScanner.git', :tag => s.version.to_s }

  s.source_files = 'CMAQRScanner/Classes/**/*'
  s.resource_bundles = {'CMAQRScanner' => ['CMAQRScanner/Assets/*']}
  
  s.ios.deployment_target = '8.0'

  s.frameworks       = 'UIKit', 'AVFoundation', 'Foundation'
  s.dependency       'MSWeakTimer'
end
