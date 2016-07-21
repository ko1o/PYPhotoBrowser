Pod::Spec.new do |s|
    s.name         = 'PYPhotosView'
    s.version      = ‘0.3.1'
    s.summary      = 'Framework with a simple method of rendering images and play video.'
    s.homepage     = 'https://github.com/iphone5solo/PYPhotosView'
    s.license      = 'MIT'
    s.authors      = {'CoderKo1o' => '499491531@qq.com'}
    s.platform     = :ios, '8.0'
    s.dependency "SDWebImage"
    s.dependency "MBProgressHUD"
    s.dependency "ASIHTTPRequest"
    s.dependency "Reachability"
    s.dependency "CocoaHTTPServer"
    s.source       = {:git => 'https://github.com/iphone5solo/PYPhotosView.git', :tag => '0.3.1'}
    s.source_files = 'PYPhotosView/**/*.{h,m}'
    s.resource     = 'PYPhotosView/PYPhotosView.bundle'
    s.requires_arc = true
    s.framework = 'UIKit'
end


