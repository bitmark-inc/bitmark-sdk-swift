# Changelog for Bitmark SDK for Swift

## 2.7.0
### Important changes:
Bitmark Swift SDK will be using new version of API as of version 2.7.  
In consequence, new API token mechanism will be applied. Instead of hardcoding a static token, the app now needs to fetch that from server and set to the sdk for every working session.  
App's backend server will be in charge of generating Bitmark SDK's API token and transfer that to clients.

## 2.6.0
### Breaking changes:
Bitmark Swift SDK v2.6.0 introduces some breaking changes to align with other Bitmark SDKs:
- Remove `Account.parseAccountNumber(accountNumber:)` in favor of `Account.validateAccountNumber(accountNumber:)`.
- Remove `AccountNumber.parse()` in favor of `AccountNumber.validate()`
- `Transfer.respond(withResponseParams:)` will return an optional String as txId when reponding with acceptance.

### Features:
- New subspec provides externsions supporting RxSwift.

## 2.0.0
### Features:
- Account: create new account, generate Recovery Phrase, recover account from Recovery Phrase
- Register Asset, Issue Bitmarks
- Query: Bitmarks, Assets, Transactions
- Transfer Bitmark
- Transfer Bitmark 2 Signatures
