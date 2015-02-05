Pod::Spec.new do |s|
  s.name             = "PushbotsLight"
  s.version          = "0.1.0"
  s.summary          = "Lightweight client for push notifications service Pushbots.com."
  s.description      = <<-DESC
                        Provides easy and transparent interface to communicate with server side.
                        The purpose of this CocoaPod was to escape for official Pushbots SDK magic and wistles.
                       DESC
  s.homepage         = "https://github.com/ikovalisko/PushbotsLight"
  s.license          = 'MIT'
  s.author           = { "Ivan Kovalisko" => "ikovalisko@gmail.com" }
  s.source           = { :git => "https://github.com/ikovalisko/PushbotsLight.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ikovalisko'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
