# Bitmark SDK for Swift
The official Bitmark SDK for Swift

[![Build Status](https://travis-ci.org/bitmark-inc/bitmark-sdk-swift.svg?branch=master)](https://travis-ci.org/bitmark-inc/bitmark-sdk-swift)
[![codecov](https://codecov.io/gh/bitmark-inc/bitmark-sdk-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/bitmark-inc/bitmark-sdk-swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/BitmarkSDK.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/BitmarkSDK.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/p/BitmarkSDK.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Setting Up
### Prerequisites
- iOS 11.0+
- Xcode 10.0+
- Swift 4.0+

### Installing
#### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build BitmarkSDK 2.0+.

To integrate BitmarkSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BitmarkSDK'

    # or

    pod 'BitmarkSDK/RxSwift'
end
```

Then, run the following command:

```bash
$ pod install
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate BitmarkSDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "bitmark-inc/bitmark-sdk-swift" ~> 2.2.0
```

Run `carthage update` to build the framework and drag the built `BitmarkSDK.framework` into your Xcode project.

#### Swift Package Manager
Comming soon....

### Importing

```swift
import BitmarkSDK
```

## Extensions
### RxSwift
[`RxSwift` extension](https://github.com/Moya/Moya/blob/master/docs/RxSwift.md) provides extension to query records / register assets / issue / transfer in [ReactiveX](http://reactivex.io) way.

## Documentation

Please refer to our [SDK Document](https://sdk-docs.bitmark.com?swift).

## Sample code
This is a [sample project](sample/). It shows how to use Bitmark SDK for Swift.

## Opening Issues
If you encounter a bug with the Bitmark SDK for Swift we would like to hear from you. Search the existing issues and try to make sure your problem doesn’t exist yet before opening a new issue. It’s helpful if you could provide the version of the SDK, Swift and OS you’re using. Please include a stack trace and reproducible case if possible.


## License

Copyright (c) 2014-2019 Bitmark Inc (support@bitmark.com).

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
