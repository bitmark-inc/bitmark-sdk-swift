Pod::Spec.new do |spec|
  spec.name = "BitmarkSDK"
  spec.version = "2.6.0"
  spec.summary = "Bitmark SDK written in Swift."
  spec.description  = <<-DESC
  The Bitmark SDK enables creation, transfer, and authentication of digital properties in the Bitmark property system. The SDK's simplified interface allows developers to easily build on the core Bitmark infrastructure by reading from and writing to the Bitmark blockchain.
                      DESC
  spec.homepage = "https://github.com/bitmark-inc/bitmark-sdk-swift"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.authors = { "Bitmark Inc." => 'support@bitmark.com' }
  spec.social_media_url = "https://twitter.com/bitmarkinc"
  spec.platform = :ios, "11.0"
  spec.requires_arc = true
  spec.source = { :git => 'https://github.com/bitmark-inc/bitmark-sdk-swift.git', :tag => spec.version }
  
  spec.subspec "Core" do |ss|
    ss.source_files  = 'BitmarkSDK/**/*.{h,c,swift}'
    ss.private_header_files = 'BitmarkSDK/tiny_sha3/*.h'
    ss.preserve_paths = 'BitmarkSDK/tiny_sha3/module.modulemap'
    ss.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/BitmarkSDK/tiny_sha3',
    }
    ss.dependency "TweetNacl"
    ss.dependency "KeychainAccess"
    ss.dependency "SwiftCentrifuge"
  end

  spec.subspec "RxSwift" do |ss|
    ss.source_files = 'RxBitmarkSDK/**/*.{swift}'
    ss.dependency "BitmarkSDK/Core"
    ss.dependency "RxSwift", "~> 5.0"
  end
end
