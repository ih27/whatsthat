# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'WhatsThat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WhatsThat
  pod 'SwiftyJSON'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
    end
end
