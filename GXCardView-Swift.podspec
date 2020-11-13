#
#  Be sure to run `pod spec lint GXCardView-Swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name          = "GXCardView-Swift"
  s.version       = "1.1.3"
  s.swift_version = "4.2"
  s.summary       = "一个卡片式布局，类似（探探附近/QQ颜值匹配）等..."
  s.homepage      = "https://github.com/gsyhei/GXCardView-Swift"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "Gin" => "279694479@qq.com" }
  s.platform      = :ios, "9.0"
  s.source        = { :git => "https://github.com/gsyhei/GXCardView-Swift.git", :tag => "1.1.3" }
  s.requires_arc  = true
  s.source_files  = "GXCardView-Swift"
  s.frameworks    = "Foundation","UIKit"

end
