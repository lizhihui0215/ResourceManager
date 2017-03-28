# Uncomment the next line to define a global platform for your project
 platform :ios, '8.0'

target 'ResourceManager' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ResourceManager
  # https://github.com/realm/realm-cocoa
  pod 'RealmSwift'
  
  # https://github.com/ninjaprox/NVActivityIndicatorView
  pod 'NVActivityIndicatorView'
  
  # https://github.com/SnapKit/SnapKit
  pod 'SnapKit'
  
  # https://github.com/hackiftekhar/IQKeyboardManager
  pod 'IQKeyboardManagerSwift'
  
  # https://github.com/jakenberg/ObjectMapper-Realm
  pod 'ObjectMapper+Realm'
  
  # https://github.com/ivanbruel/Moya-ObjectMapper
  pod 'Moya-ObjectMapper/RxSwift'
  
  # https://github.com/ReactiveX/RxSwift
  pod 'RxSwift'
  pod 'RxCocoa'

  target 'ResourceManagerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ResourceManagerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
