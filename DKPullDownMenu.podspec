Pod::Spec.new do |s|
    s.name         = "DKPullDownMenu"
    s.version      = "0.0.1"
    s.ios.deployment_target = '7.0'
    s.summary      = "A pullDown menu for iOS, support single-select, multi-select and customization".
    s.homepage     = "https://github.com/bingozb/DKPullDownMenu"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "bingozb" => "454113692@qq.com" }
    s.source       = { :git => "https://github.com/bingozb/DKPullDownMenu.git", :tag => "v0.0.1" }
    s.source_files  = "DKPullDownMenu/*.{h,m}"
    s.resources          = "DKPullDownMenu/DKPullDownMenu.bundle"
    s.requires_arc = true
end