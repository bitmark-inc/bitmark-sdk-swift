//: Playground - noun: a place where people can play

import BitmarkSDK

let seed = try Seed(fromBase58: "5XEECsKPsXJEZRQJfeRU75tEk72WMs87jW1x9MhT6jF3UxMVaAZ7TSi")
let seedCombine = seed.base58String
let network = seed.network.name
let core = seed.core.hexEncodedString

let seed1 = try Seed(version: 1, network: Config.liveNet)
seed1.base58String
let seed2 = try Seed(fromBase58: seed1.base58String)
seed2.version
