Pod::Spec.new do |s|
    s.name         = 'PYPhotosView'
    s.version      = '0.1.1'
    s.summary      = 'Framework with a simple method of rendering images.'
    s.homepage     = 'https://github.com/iphone5solo/PYPhotosView'
    s.license      = 'MIT'
    s.authors      = {'CoderKo1o' => '499491531@qq.com'}
    s.platform     = :ios, '7.0'
    s.dependency "SDWebImage", "~> 3.8.1"
    s.dependency "MBProgressHUD", "~>0.9.2"
    s.source       = {:git => 'https://github.com/iphone5solo/PYPhotosView.git', :tag => '0.1.1'}
    s.source_files = 'PYPhotosView/**/*.{h,m}'
    s.resource     = 'PYPhotosView/PYPhotosView.bundle'
    s.requires_arc = true
    s.framework = 'UIKit'
end


