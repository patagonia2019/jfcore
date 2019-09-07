#
# Be sure to run `pod lib lint JFCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JFCore'
  s.version          = '1.0'
  s.summary          = 'JFCore is my library to work with location, error, core data, and some extensions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
JFCore contains Accessiblity, Location, Error, Analytics and CoreDataManager classes.
                       DESC

  s.homepage         = 'https://github.com/southfox'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Javier Fuchs' => 'mobilepatagonia@gmail.com' }
  s.source = { :git => "https://github.com/southfox/jfcore.git", :tag => s.version.to_s }

  s.subspec 'new' do |new|
    new.ios.deployment_target = '12.0'
    new.ios.source_files = 'JFCore/Classes/**/*.swift'
  end
  s.subspec 'old' do |old|
    old.ios.deployment_target = '9.0'
    old.ios.source_files = 'JFCore/Classes/**/*.swift'
  end
  s.osx.deployment_target = '10.14'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '5.2'

  s.osx.source_files = 'JFCore/Classes/**/*.swift'
  s.tvos.source_files = 'JFCore/Classes/**/*.swift'
  s.watchos.source_files = 'JFCore/Classes/all/**/*.swift'
  
end
