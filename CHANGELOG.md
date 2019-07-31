# Changelog for Bitmark SDK for Swift

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
