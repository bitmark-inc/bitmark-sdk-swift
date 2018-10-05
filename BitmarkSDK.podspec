Pod::Spec.new do |spec|
  spec.name = "BitmarkSDK"
  spec.version = "0.0.5"
  spec.summary = "Bitmark library written in Swift."
  spec.homepage = "https://github.com/bitmark-inc/bitmark-sdk-swift"
  spec.license = 'MIT'
  spec.authors = { "Bitmark Inc" => 'support@bitmark.com' }
  spec.social_media_url = "https://twitter.com/bitmarkinc"

  spec.platform = :ios, "11.0"
  spec.requires_arc = true
  spec.source = { :git => 'https://github.com/bitmark-inc/bitmark-sdk-swift.git', :tag => spec.version }
  spec.source_files = 'BitmarkSDK/**/*.{h,swift}'
  spec.ios.vendored_library    = 'BitmarkSDK/libsodium/libsodium-ios.a'
  spec.osx.vendored_library    = 'BitmarkSDK/libsodium/libsodium-osx.a'
  spec.private_header_files = 'BitmarkSDK/libsodium/*.h', 'BitmarkSDK/tiny_sha3/*.h'
  spec.preserve_paths = 'BitmarkSDK/libsodium/module.modulemap', 'BitmarkSDK/tiny_sha3/module.modulemap'
  spec.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/BitmarkSDK/libsodium $(PODS_TARGET_SRCROOT)/BitmarkSDK/tiny_sha3',
  }

  spec.requires_arc = true

  spec.dependency "TweetNacl"
end
