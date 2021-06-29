source 'https://cdn.cocoapods.org/'
# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Example' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Example
pod 'ElegantSnap'
pod 'RxCocoa'
pod 'Alamofire'
end

target 'MyBase' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyBase
pod 'ElegantSnap'
pod 'RxCocoa'
pod 'Alamofire'
end

post_install do |installer|
    # config pods_project
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = 'YES'
      if config.name == 'Debug'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
  end
    
    # config each target of pods_project
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
           config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
end
