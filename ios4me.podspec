Pod::Spec.new do |s|
  s.name         = 'ios4me'
  s.version      = '1.0.2'
  s.homepage     = 'http://www.smartnsoft.com'
  s.license      = 'LGPL'
  s.summary      = 'An iOS framework built by Smart&Soft, cutting edge mobile agency in France.'
  s.description  = 'ios4me (also known as the Smart&Soft framework) is developed and maintained by Smart&Soft. We create cutting edge iOS and Android applications for our customers.'
  s.author = {
    'Smart&Soft' => 'contact@smartnsoft.com'
  }
  s.source = {
    :git => 'https://github.com/smartnsoft/ios4me.git',
    :tag => '1.0.2'
  }
  s.platform              = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  
  s.ios.source_files      = 'SnSFramework/SnSFramework/ios4me/Classes/**/*.{h,m}'
  s.ios.frameworks        = 'UIKit', 'QuartzCore', 'Foundation', 'Security'
  
  s.ios.dependency        'ASIHTTPRequest', '~> 1.8.1'
  #s.ios.dependency        'AFNetworking', '~> 1.3.2'
  #s.ios.dependency        'MKNetworkKit', '~> 0.87'

end