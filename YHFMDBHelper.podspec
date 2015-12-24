Pod::Spec.new do |s|

  s.name         = "YHFMDBHelper"
  s.version      = '0.1.0'
  s.summary      = "SQL helpers for FMDB"
  s.description  = <<-DESC
                   Helper categories for FMDB to spell SQL statements,
                   and easy use FMDB with Model Mapping.
                   DESC

  s.homepage          = "https://github.com/YouSelf/YHFMDBHelper"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  
  s.author            = { "wangyuehong" => "wang_gnawer@163.com" }
  s.social_media_url  = "http://www.302li.com"

  s.source            = { :git => "https://github.com/YouSelf/YHFMDBHelper.git", :tag => s.version.to_s }
  s.source_files      = "Sources"
  s.requires_arc      = true
  
  s.dependency "FMDB", "~> 2.3"

end
