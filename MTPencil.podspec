#
# Be sure to run `pod spec lint MTPencil.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "MTPencil"
  s.version      = "0.0.1"
  s.summary      = "Library for animated line drawing (like an invisible pencil)."
  s.homepage     = "https://github.com/mysterioustrousers/MTPencil"
  s.license      = 'BSD'
  s.author       = { "Adam Kirk" => "atomkirk@gmail.com" }
  s.source       = { :git => "https://github.com/mysterioustrousers/MTPencil.git", :tag => "0.0.1" }
  s.source_files = 'MTPencil.{h,m}'
  s.framework  = 'CoreGraphics'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # Specify a list of libraries that the application needs to link
  # against for this Pod to work.
  #
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  # If this Pod uses ARC, specify it like so.
  #
  # s.requires_arc = true

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  # s.dependency 'JSONKit', '~> 1.4'
end
