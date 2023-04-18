# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'        #官方仓库地址
source 'git@repo.we.com:ios/tspecsrepo.git'       #私有仓库地址
#source 'http://repo.we.com/ios/tspecsrepo.git'

target 'Demo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Demo
  pod 'Masonry'
  pod 'AFNetworking'
  pod 'ReactiveObjC'
  pod 'MJExtension'
  pod 'YYKit'
  pod 'LookinServer', :configurations => ['Debug'] #界面查看工具
  pod 'TMUICore', '2.0.25'
  pod 'TMUIExtensions', '2.0.25'
  pod 'TMUIComponents', '2.0.25'
  pod 'ChainUIKit'
  pod 'TMEmptyView'
  pod 'TMToast'
  pod 'MJRefresh'
  pod 'MBProgressHUD'
  pod 'Lottie'
  pod 'IQKeyboardManager'
#  pod 'YYWebImage', '1.0.5'

  target 'DemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DemoUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end


end
