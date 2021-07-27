#
# Be sure to run `pod lib lint PGViewInteraction.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PGViewInteraction'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PGViewInteraction.'

  s.description      = 'Extension of UIView for easy spring touch interaction.'

  s.homepage         = 'https://github.com/ipagong/PGViewInteraction'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ipagong' => 'ipagong.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/ipagong/PGViewInteraction.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '11.0'

  s.source_files = 'PGViewInteraction/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PGViewInteraction' => ['PGViewInteraction/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
