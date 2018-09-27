Pod::Spec.new do |spec|
  spec.name = "BitmarkSDK"
  spec.version = "2.0.0"
  spec.summary = "Bitmark SDK written in Swift."
  spec.homepage = "https://github.com/bitmark-inc/bitmark-sdk-swift"
  spec.license = 'MIT'
  spec.authors = { "Bitmark Inc" => 'support@bitmark.com' }
  spec.social_media_url = "https://twitter.com/bitmarkinc"

  spec.platform = :ios, "11.0"
  spec.requires_arc = true
  spec.source = { :git => 'https://github.com/bitmark-inc/bitmark-sdk-swift.git', :tag => spec.version }
  spec.source_files = 'BitmarkSDK/**/*.{h,swift}'

  spec.requires_arc = true

  spec.dependency "BigInt"
  spec.dependency "CryptoSwift"
  spec.dependency "TweetNacl"
end
