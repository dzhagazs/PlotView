#
# Be sure to run `pod lib lint PlotView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PlotView'
  s.version          = '0.1.0'
  s.summary          = 'A simple view for displaying information as a two-dimensional graph. Implemented using SwiftUI.'
  s.description      = 'A simple view for displaying information as a two-dimensional graph. Implemented using SwiftUI. Suitable for displaying small simple graphs inside table view cell, also allows displaying detailed information including grid lines, scale labels, and changing scale for each axis separately.'
  s.homepage         = 'https://github.com/dzhagaz/PlotView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dzhagaz' => 'dzhagaz.sasha@gmail.com' }
  s.source           = { :git => 'https://github.com/dzhagaz/PlotView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.source_files = 'PlotView/**/*'
  
end
