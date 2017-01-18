Pod::Spec.new do |spec|
  spec.name = "BitmarkLib"
  spec.version = "0.0.3"
  spec.summary = "Bitmark library written on Swift."
  spec.homepage = "https://github.com/bitmark-inc/bitmark-lib-swift"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Bitmark Inc" => 'support@bitmark.com' }
  spec.social_media_url = "https://twitter.com/bitmarkinc"

  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/bitmark-inc/bitmark-lib-swift.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = 'BitmarkLib/**/*.{h,swift}', 'DNSServiceDiscovery/**/*.{h,swift}'
  spec.xcconfig = { "SWIFT_INCLUDE_PATHS[sdk=iphoneos*]" => "$(PODS_ROOT)/BitmarkLib/DNSServiceDiscovery/iphoneos.modulemap",
"SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]" => "$(PODS_ROOT)/BitmarkLib/DNSServiceDiscovery/iphonesimulator.modulemap",
"SWIFT_INCLUDE_PATHS[sdk=macosx*]" => "$(PODS_ROOT)/BitmarkLib/DNSServiceDiscovery/macos.modulemap" }


  spec.preserve_paths = 'BitmarkLib/DNSServiceDiscovery/iphoneos.modulemap', 'BitmarkLib/DNSServiceDiscovery/iphonesimulator.modulemap', 'BitmarkLib/DNSServiceDiscovery/macos.modulemap'

  spec.dependency "BigInt", "~> 2.1"
  spec.dependency "CryptoSwift"
  spec.dependency "TweetNacl"
end
