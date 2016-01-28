Pod::Spec.new do |s|
  s.name             = "WindowCapture"
  s.version          = "0.1.0"
  s.summary          = "Swift wrapper for CGWindow APIs + RX"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  Swift wrapper for CGWindow APIs + RX.
  Makes easy to capture the windows that are opened in OS X.
                       DESC

  s.homepage         = "https://github.com/alexito4/WindowCapture"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alejandro Martínez" => "alexito4@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/WindowCapture.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexito4'

  s.platform     = :osx
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'Quartz'
  s.dependency 'RxSwift', '~> 2.0'
end
