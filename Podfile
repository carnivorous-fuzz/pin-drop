# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PinDrop' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PinDrop
  # Parse
  pod 'Parse'

  pod 'ParseLiveQuery'
  pod 'ParseFacebookUtilsV4'

  # AWS SDKs
  pod 'AWSCognito'
  pod 'AWSCore'
  pod 'AWSS3'
  pod 'SwiftDate', '~> 4.3.0'

  #Mapbox
  pod 'Mapbox-iOS-SDK', '~> 3.6'
  pod 'MapboxNavigation', '~> 0.9'

  # Other
  pod 'KMPlaceholderTextView', '~> 1.3.0'
  pod 'AFNetworking'
  pod 'Fusuma'
  pod 'NVActivityIndicatorView'
  pod 'PopupDialog', '~> 0.6'
  pod 'FBSDKLoginKit'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.2'
          end
      end
  end
end
