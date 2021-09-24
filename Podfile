# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'        #官方仓库地址
source 'git@repo.we.com:ios/tspecsrepo.git'       #私有仓库地址
source 'http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecs.git'


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
#  pod 'MLeaksFinder', :configurations => ['Debug'] #检测内存泄漏
#  pod 'TMUIKit', :git => 'https://github.com/chengzongxin/TMUIKit.git' #TMUI
  pod 'TMUIKit', :path => '/Users/joe.cheng/tmuikit/TMUIKit_Debug.podspec'
#  pod 'TMUIKit', '1.1.7'
  pod 'MJRefresh'
  pod 'MBProgressHUD'
  pod 'THKOSSManager', '1.1.6'


  target 'DemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DemoUITests' do
    # Pods for testing
  end

end
