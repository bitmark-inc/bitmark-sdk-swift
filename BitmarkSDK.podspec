Pod::Spec.new do |spec|
  spec.name = "BitmarkSDK"
  spec.version = "0.0.3"
  spec.summary = "Bitmark library written on Swift."
  spec.homepage = "https://github.com/bitmark-inc/bitmark-lib-swift"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Bitmark Inc" => 'support@bitmark.com' }
  spec.social_media_url = "https://twitter.com/bitmarkinc"

  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/bitmark-inc/bitmark-lib-swift.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = 'BitmarkSDK/**/*.{h,swift}', 'DNSServiceDiscovery/**/*.{h,swift}'
  spec.xcconfig = { "SWIFT_INCLUDE_PATHS[sdk=iphoneos*]" => "$(PODS_ROOT)/BitmarkSDK/BitmarkSDK/DNSServiceDiscovery/iphoneos",
"SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]" => "$(PODS_ROOT)/BitmarkSDK/BitmarkSDK/DNSServiceDiscovery/iphonesimulator",
"SWIFT_INCLUDE_PATHS[sdk=macosx*]" => "$(PODS_ROOT)/BitmarkSDK/BitmarkSDK/DNSServiceDiscovery/macosx" }


  spec.preserve_paths = 'BitmarkSDK/DNSServiceDiscovery/iphoneos/module.map', 'BitmarkSDK/DNSServiceDiscovery/iphonesimulator/module.map', 'BitmarkSDK/DNSServiceDiscovery/macosx/module.map'

  spec.dependency "BigInt"
  spec.dependency "CryptoSwift"
  spec.dependency "TweetNaclSwift"
end
