# Bitmark SDK for Swift

[![Build Status](https://travis-ci.org/bitmark-inc/bitmark-lib-swift.svg?branch=master)](https://travis-ci.org/bitmark-inc/bitmark-lib-swift)
[![codecov](https://codecov.io/gh/bitmark-inc/bitmark-lib-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/bitmark-inc/bitmark-lib-swift)

BitmarkSDK written in Swift.

## Requirements

- iOS 10.0+
- Xcode 9.0+
- Swift 4.0+

## Installation
### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build BitmarkSDK 1.0+.

To integrate BitmarkSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BitmarkSDK'
end
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager
Comming soon....

## Set up

```swift
import BitmarkSDK
```

## Usage

### Seed

#### Set up

```swift
let seed = try Seed()
```

Seed is where everything starts for an entity which wants to use bitmark services.
A seed is used to generate:
1. auth key: for authentication of transactions (issue or transfer)
2. encryption key: for encryption of assets

To create a new random seed:

```swift
let seed = try Seed()
```

There are 2 optional parameters for the Seed constructor: *network* and *version*. The default for *network* is `livenet`, and the only supported version now is 1.

```swift
let seed = try Seed(version: 1)
let seed = try Seed(network: Network.testnet)
let seed = try Seed(version: 1, network: Network.livenet)
```

Losing the seed means losing the control over bitmarks and assets of the entity.
Thus, a seed should be backed up by saving its string format in a secure place, and be imported when there are operations which require authentication or encryption.

```swift
let backup = seed.base58String
let resore = try Seed(fromBase58: backup) // Throw error when the seed is invalid
```

### Auth Key

#### Instantiate

To create the auth key from a new seed:
```swift
    guard let seedCore = Common.randomBytes(length: 32) else {
        // failed to generate random bytes, throw error
    }

    let authKey = try AuthKey(fromKeyPair: seedCore)
```

There are 2 optional parameters for the AuthKey constructor: *network* and *key type*. The default for *network* is `livenet`, and the default for *key type* is `ed25519`.

```swift
    let authKey = try AuthKey(fromKeyPair: seedCore, network: Network.testnet)
    let authKey = try AuthKey(fromKeyPair: seedCore, network: Network.livenet, type: KeyType.ed25519)
```

To parse the private key from the KIF string:

```swift
    let authKey = try AuthKey(fromKIF: "dvSQZidUCWm179wQZFPWm1GxpWqmhw6eTov72dQRDEqwoyJhWZ")
```

---

### AccountNumber

#### Instantiate

To instantiate an AccountNumber object from an account number string:

```swift
    let accountNumber = try AccountNumber(address: "fL3jywNn8T2hJa6EV7Gm1bR7MAQx4rFtMD8RtayYnvturtJvC7")
```

To instantiate an AccountNumber object from a Data object:

```swift
    let accountNumber = AccountNumber(fromPubKey: "73346e71883a09c0421e5d6caa473239c4438af71953295ad903fea410cabb44".hexDecodedData)
    let accountNumber = AccountNumber(fromPubKey: "73346e71883a09c0421e5d6caa473239c4438af71953295ad903fea410cabb44".hexDecodedData, network: Network.testnet, keyType: KeyType.ed25519)
```

Note:
* `network` and `keytype` are optional, the defaults are `livenet` and `ed25519`.
* When instantiating a AccountNumber from a Data object using the constructor function, input the Data object instead of a hexadecimal string value.

#### Properties

* *string* — returns the account number as a string
* *network* — returns either `livenet` or `testnet`, depending on the account number
* *pubKey* — returns the public key as a hexadecimal string value
* *keyType* — returns the key type (currently only `ed25519`)

---

## Records

### Asset Record

#### Instantiate

To instantiate an Asset record object:

```swift
    var asset = Asset()
    try asset.set(name: "Just want to test it")
    try asset.set(metadata: ["description": "this is description"])
    try asset.set(fingerPrint: "w3845723904723094asdasd7238942234")
    try asset.sign(withPrivateKey: authKey)
```

#### Properties
* *isSigned* — returns `true` if the asset record is signed
* *name* — returns the string value for an Asset's *Name* property
* *metadata* - the metadata for the asset
* *fingerprint* — returns the hexadecimal value for an Asset's *Fingerprint* property
* *registrant* — returns an AccountNumber object specifying the Asset's *Registrant* property
* *signature* — returns the Asset object's signature buffer
* *id* — returns the Asset object's 'AssetIndex' as a string value


### Issue Record

#### Instantiate

To instantiate an Issue record object:

```swift
    var issue = Issue()
    issue.set(asset: asset)
    issue.set(nonce: issueNonce)
    try issue.sign(privateKey: authKey)
```

#### Properties
* *isSigned* — returns `true` if the issue record is signed
* *owner* — returnss an AccountNumber object specifying the Issue record's *Owner* property
* *signature* — returns the Issue object's signature buffer
* *asset*: returns the Issue record's corresponding *Asset*
* *txId* — returns a hexadecimal string id for the Issue record

---

### Transfer

#### Instantiate

To instantiate a Transfer record object:

```swift
    var transfer = Transfer()
    try transfer.set(from: "c5be32754022c7b4075ec7c8524935a4b6bbdd6e4db451259d1a4dd19a8321a3")
    try transfer.set(to: transferTo)
    try transfer.sign(privateKey: authKey)
```

Note: `set(from:` can receive either an Issue or Transfer object *or* an id string from either an Issue or Transfer object.

#### Methods
* *isSigned* — returns `true` if the transfer record is signed
* *owner* —  returns an AccountNumber object specifying the the Transfer record's *Owner* property
* *signature*: returns the Transfer object's signature buffer
* *preTxId*: returns a hexadecimal string of the *Id* for the previous record in the chain-of ownership (either an Issue record or Transfer record) — the same as a record's *Link* property in the blockchain data structure
* *txId* — returns a hexadecimal string id for the Transfer record

---

## Utilities

### Fingerprint

#### Methods
* *computeFingerprint(data:* - returns a fingerprint string from data content
* *computeFingerprint(fromFile:* - returns a fingerprint string from string content

### Encryption

#### Methods
* *encryptFile(fromFile:* - returns a fingerprint string from data content

--


# License

Copyright (c) 2014-2017 Bitmark Inc (support@bitmark.com).

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