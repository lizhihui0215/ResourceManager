# Uncomment the next line to define a global platform for your project
 platform :ios, '8.0'

target 'ResourceManager' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for ResourceManager
  pod 'PCCWFoundationSwift'

  pod 'DLAlertView'

  pod 'ZXingObjC'

  pod 'MBProgressHUD'

  pod 'KissXML'

  pod 'GPUImage'

  pod 'AMap3DMap'  #3D地图SDK

  pod 'AMapSearch' #搜索功能

  pod 'AMapLocation'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
        # swift4 = Array['CryptoSwift', 'RSKGrowingTextView', 'RSKPlaceholderTextView']
        #   if swift4.include? target.name then
        #       target.build_configurations.each do |config|
        #           config.build_settings['SWIFT_VERSION'] = '4.0'
        #       end
        #       else
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '4.0'
              end
          # end
      end
  end

  target 'ResourceManagerTests' do
    inherit! :search_paths

    # Pods for testing
  end

  target 'ResourceManagerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
