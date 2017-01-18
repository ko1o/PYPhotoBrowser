Pod::Spec.new do |s|
    s.name         = 'PYPhotoBrowser'
    s.version      = '1.2.5'
    s.summary      = 'An easy way to browse photo(image) for iOS.'
    s.homepage     = 'https://github.com/iphone5solo/PYPhotoBrowser'
    s.license      = 'MIT'
    s.authors      = {'CoderKo1o' => '499491531@qq.com'}
    s.platform     = :ios, '7.0'
    s.dependency "SDWebImage"
    s.dependency "MBProgressHUD"
    s.dependency "DACircularProgress"
    s.source       = {:git => 'https://github.com/iphone5solo/PYPhotoBrowser.git', :tag => s.version}
    s.source_files = 'PYPhotoBrowser/**/*.{h,m}'
    s.resource     = 'PYPhotoBrowser/PYPhotosView.bundle'
    s.requires_arc = true
end


