platform :ios, '11.0'

project 'CofCApp.xcodeproj'
target 'CofCApp' do

source 'https://github.com/forcedotcom/SalesforceMobileSDK-iOS-Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

pod 'SalesforceSDKCommon', :path => 'mobile_sdk/SalesforceMobileSDK-iOS'
pod 'SalesforceAnalytics', :path => 'mobile_sdk/SalesforceMobileSDK-iOS'
pod 'SalesforceSDKCore', :path => 'mobile_sdk/SalesforceMobileSDK-iOS'
pod 'SmartStore', :path => 'mobile_sdk/SalesforceMobileSDK-iOS'
pod 'SmartSync', :path => 'mobile_sdk/SalesforceMobileSDK-iOS'

end

# Comment the following if you do not want the SDK to emit signpost events for instrumentation. Signposts are  enabled for non release version of the app.
 post_install do |installer_representation|
       installer_representation.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
               if config.name == 'Debug'
                   config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'DEBUG=1','SIGNPOST_ENABLED=1']
                   config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-DDEBUG','-DSIGNPOST_ENABLED']
               end
           end
       end
  end
