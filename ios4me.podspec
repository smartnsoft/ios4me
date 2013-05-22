Pod::Spec.new do |s|
  s.name         = 'ios4me'
  s.version      = '1.0.0'
  s.homepage     = 'http://www.smartnsoft.com'
  s.license      = 'LGPL'
  s.summary      = 'ios4me (also known as the Smart&Soft framework) is developed and maintained by Smart&Soft. We create cutting edge iOS and Android applications for our customers.'
  s.author = {
    'Smart&Soft' => 'contact@smartnsoft.com'
  }
  s.source = {
    :git => 'https://github.com/smartnsoft/ios4me.git',
    :tag => '1.0.0'
  }
  s.source_files = 'SnSFramework/SnSFramework/ios4me/Classes/*.{h,m}'
#  s.dependency     'AF'
end