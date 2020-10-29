Pod::Spec.new do |s|
  s.name             = 'MobileConsentsSDK'
  s.version          = '0.1.2'
  s.summary          = 'Mobile Consents Framework for iOS'
  s.homepage         = 'https://bitbucket.org/cookieinformation/mobileconsents-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jonas Voldbjerg Andersen' => 'ja@cookieinformation.com' }
  s.source           = { :git => 'https://bitbucket.org/cookieinformation/mobileconsents-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = 'sources/MobileConsentsSDK.xcframework'
end
