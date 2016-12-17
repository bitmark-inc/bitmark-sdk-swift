//: Playground - noun: a place where people can play

import BitmarkLib

let str = "Hello, playground"
let data1 = str.data(using: .utf8)!
let base58data1 = BitmarkLib.encode(data1)

let data2 = BitmarkLib.decode(base58data1)!
let str2 = String(data: data2, encoding: .utf8)