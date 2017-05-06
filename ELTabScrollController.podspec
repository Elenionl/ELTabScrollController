
Pod::Spec.new do |s|

  s.name         = "ELTabScrollController"
  s.version      = "0.1.3"
  s.summary      = "Easily Used Tab Scroll ViewController with Swift 3"
  s.description  = <<-DESC
  ELTabScrollController is an easily used Tab Scroll Controller suit. It is build with pure code without storyboard or xib, making it easy to inherate.
  (Drawing lines is quite boring, and may cause bugs hard to fix)
  ELPickerView is easy to use as well as flexable. there are rich document and annotation for ELTabScrollController.
                   DESC
  s.homepage     = "https://github.com/Elenionl/ELTabScrollController"
  s.screenshots  = "https://raw.githubusercontent.com/Elenionl/ELTabScrollController/master/screenshots/2017-04-23%2000.40.02.gif"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author             = { "Hanping Xu" => "stellanxu@gmail.com" }
  s.social_media_url   = "https://github.com/Elenionl"
  s.platform     = :ios, '9.0'
  s.source       = { :git => "https://github.com/Elenionl/ELTabScrollController.git", :tag => "#{s.version}" }
  s.source_files  = "ELTabScrollController/ELTabScrollController/*.swift"
  s.requires_arc = true
  s.frameworks = 'UIKit'
  s.dependency 'SnapKit'
end
# pod spec lint ELTabScrollController.podspec
# pod trunk push ELTabScrollController.podspec
