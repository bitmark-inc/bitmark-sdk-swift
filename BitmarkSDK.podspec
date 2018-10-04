Pod::Spec.new do |spec|
  spec.name = "BitmarkSDK"
  spec.version = "2.0.1"
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
  spec.source_files = 'BitmarkSDK/**/*.{h,swift}'

  spec.dependency "BigInt"
  spec.dependency "CryptoSwift"
  spec.dependency "TweetNacl"
end
