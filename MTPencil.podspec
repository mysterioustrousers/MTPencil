Pod::Spec.new do |s|
  s.name         = "MTPencil"
  s.version      = "0.0.1"
  s.summary      = "Library for animated line drawing (like an invisible pencil)."
  s.homepage     = "https://github.com/mysterioustrousers/MTPencil"
  s.license      = 'BSD'
  s.author       = { "Adam Kirk" => "atomkirk@gmail.com" }
  s.source       = { :git => "https://github.com/mysterioustrousers/MTPencil.git", :tag => "0.0.1" }
  s.platform     = :ios
  s.source_files = 'MTPencil/MTPencil.{h,m}'
  s.framework  = 'CoreGraphics'
  s.requires_arc = true
  s.dependency 'MTGeometry'
end