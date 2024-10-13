# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UIKit-Code-Based-Project' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UIKit-Code-Based-Project
    pod 'Alamofire', '~> 5.2'
    pod 'ReactorKit'
    pod 'RxSwift', '~> 5'
    pod 'RxCocoa', '~> 5'
    pod 'SnapKit', '~> 5'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
