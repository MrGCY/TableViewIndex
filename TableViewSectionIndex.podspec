
Pod::Spec.new do |s|
  s.name         = "TableViewSectionIndex"
  s.version      = "0.0.1"
  s.summary      = "tableView的一个自定义索引"
  s.description  = <<-DESC
                    列表的索引，类似通讯录左侧的索引，高仿微信
                   DESC

  s.homepage     = "https://github.com/MrGCY"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "MrGCY" => "Mr_GCY@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/MrGCY/TableViewIndex.git", :tag => s.version.to_s}
  s.source_files  = "TableViewSectionIndex/Custom/**/*.{h,m}", "TableViewSectionIndex/*.{h,m}"
  s.resources = "TableViewSectionIndex/Resource/*"
  s.requires_arc = true
end
