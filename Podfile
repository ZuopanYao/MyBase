source 'https://cdn.cocoapods.org/'
platform :ios, '12.1'
use_frameworks!

def common
  pod 'ElegantSnap'
  pod 'RxCocoa'
  pod 'Alamofire'
end

target 'Example' do
  common
end

target 'MyBase' do
  common
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = 'YES'
      if config.name == 'Debug'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
  end
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
           config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
      end
    end
end
