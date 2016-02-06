source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!
link_with 'ImageDownloader', 'ImageDownloaderTests'

def shared_pods
  pod 'netfox'
  pod 'Kingfisher', :git => 'https://github.com/MMrepo/Kingfisher.git'
  pod 'PromiseKit'
  pod 'SGImageCache', :git => 'https://github.com/MMRepo/SGImageCache.git', :branch => 'compatibleVersion'
end

def testing_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'OHHTTPStubs'
  pod 'OHHTTPStubs/Swift'
end

target 'ImageDownloaderTests',  :exclusive => true do
    shared_pods
    testing_pods
end

target 'ImageDownloader' do
	shared_pods
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if(target.name == 'Pods-SGImageCache')
            target.build_configurations.each do |config|
                config.build_settings['OTHER_LDFLAGS'] = '-framework AFNetworking'
            end
        end
    end
end