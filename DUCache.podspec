#
# Be sure to run `pod lib lint DUCache.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DUCache"
  s.version          = "0.1.0"
  s.summary          = "An experiment."
  s.description      = "Mini caching library."
  s.homepage         = "https://github.com/essame/DUCache"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Essam" => "essam.a0@gmail.com" }
  s.source           = { :git => "https://github.com/essame/DUCache.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'DUCache'
  s.resource_bundles = {
    'DUCache' => []
  }

  s.public_header_files = 'DUCache/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
