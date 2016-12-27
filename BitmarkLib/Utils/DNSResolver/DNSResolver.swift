//
//  DNSResolver.swift
//  BitmarkLib
//
//  From https://github.com/JadenGeller/Burrow-Client
//  Ported to Swift 3 by Anh Nguyen on 12/24/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import DNSServiceDiscovery

private struct QueryInfo {
    var service: DNSServiceRef?
    var socket: CFSocket!
    var socketSource: CFRunLoopSource!
    var records: Result<[TXTRecord]>
    var responseHandler: (Result<[TXTRecord]>) -> ()
    var totalPacketCount: Int?
    var timer: CFRunLoopTimer!
}

extension QueryInfo {
    func performCleanUp() {
        // Remove socket listener from run look, destory socket, and deallocate service
        CFRunLoopSourceInvalidate(socketSource)
        CFRunLoopTimerInvalidate(timer)
        CFSocketInvalidate(socket)
        DNSServiceRefDeallocate(service)
    }
}

private func queryCallback(
    sdref: DNSServiceRef?,
    flags: DNSServiceFlags,
    interfaceIndex: UInt32,
    errorCode: DNSServiceErrorType,
    fullname: UnsafePointer<Int8>?,
    rrtype: UInt16,
    rrclass: UInt16,
    rdlen: UInt16,
    rdata: UnsafeRawPointer?,
    ttl: UInt32,
    context: UnsafeMutableRawPointer?
    ) {
    
    guard let queryContext = context?.assumingMemoryBound(to: QueryInfo.self) else {
        return
    }
    
    do {
        if Int(errorCode) > 0 {
            throw BMError("query failed")
        }
        
        // Parse the TXT record
        let txtBuffer = UnsafeBufferPointer<UInt8>(start: rdata?.assumingMemoryBound(to: UInt8.self), count: Int(rdlen))
        guard let txtRecord = TXTRecord(buffer: txtBuffer) else {
            throw BMError("query failed")
        }
        
        queryContext.pointee.records.mutate { array in
            array.append(txtRecord)
        }
    } catch {
        queryContext.pointee.records = .failure(error)
        queryContext.pointee.performCleanUp()
    }
}

private func querySocketCallback(
    socket: CFSocket?,
    callbackType: CFSocketCallBackType,
    address: CFData?,
    data: UnsafeRawPointer?,
    info: UnsafeMutableRawPointer?
    ) {
    
    precondition(callbackType == .readCallBack)
    guard let queryContext = info?.assumingMemoryBound(to: QueryInfo.self) else {
        return
    }
    precondition(socket === queryContext.pointee.socket)
    
    // Process the result
    let status = DNSServiceProcessResult(queryContext.pointee.service)
    
    queryContext.pointee.records.mutate { _ in
        if Int(status) != kDNSServiceErr_NoError {
            queryContext.pointee.performCleanUp()
            throw BMError("query failed")
        }
    }
    
    // Ensure that we wait for all the records we expect to receive.
//    if case .success(let records) = queryContext.pointee.records {
//        guard records.count == queryContext.pointee.totalPacketCount else { return }
//        queryContext.pointee.performCleanUp()
//    }
    queryContext.pointee.performCleanUp()
    queryContext.pointee.responseHandler(queryContext.pointee.records)
    queryContext.deinitialize()
    queryContext.deallocate(capacity: 1)
    
}

private func timerCallback(timer: CFRunLoopTimer?, info: UnsafeMutableRawPointer?) {
    guard let queryContext = info?.assumingMemoryBound(to: QueryInfo.self) else {
        return
    }
    
    queryContext.pointee.responseHandler(Result {
        throw BMError("time out")
    })
    queryContext.pointee.performCleanUp()
    queryContext.deinitialize()
    queryContext.deallocate(capacity: 1)
}

public class DNSResolver {
    private init() { }
    
    public static func resolveTXT(_ domain: String, timeout: Double = 60, handler: @escaping (Result<[TXTRecord]>) -> ()) {
        
        // Create space on the heap for the context
        let queryContext = UnsafeMutablePointer<QueryInfo>.allocate(capacity: 1)
        queryContext.initialize(to: QueryInfo(
            service: nil,
            socket: nil,
            socketSource: nil,
            records: .success([]),
            responseHandler: handler,
            totalPacketCount: nil,
            timer: nil
        ))
        
        // Create DNS Query
        var service: DNSServiceRef? = nil
        
        let status = domain.withCString { fullname in
            DNSServiceQueryRecord(
                &service, /* serviceRef: */
                0, /* flags: */
                0, /* interfaceIndex: */
                fullname, /* fullname: */
                UInt16(kDNSServiceType_TXT), /* rrtype: */
                UInt16(kDNSServiceClass_IN), /* rrclass: */
                queryCallback, /* callback: */
                queryContext /* context: */
            )
        }
        if Int(status) != kDNSServiceErr_NoError {
            handler(.failure(BMError("query failed")))
        }
        
        precondition(service != nil)
        queryContext.pointee.service = service!
        
        // Create socket to query
        var socketContext = CFSocketContext(
            version: 0,
            info: queryContext,
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        let socketIdentifier = DNSServiceRefSockFD(service)
        precondition(socketIdentifier >= 0)
        let socket = CFSocketCreateWithNative(
            nil, /* allocator: */
            socketIdentifier, /* socket: */
            CFSocketCallBackType.readCallBack.rawValue, /* callbackTypes: */
            querySocketCallback, /* callout: */
            &socketContext /* context: */
        )
        
        queryContext.pointee.socket = socket
        
        // Add socket listener to run loop
        let socketSource = CFSocketCreateRunLoopSource(
            nil, /* allocator: */
            socket, /* socket: */
            0 /* order: */
        )
        
        queryContext.pointee.socketSource = socketSource
        CFRunLoopAddSource(CFRunLoopGetMain(), socketSource, CFRunLoopMode.defaultMode)
        
        // Add timeout timer to run loop
        var timerContext = CFRunLoopTimerContext(
            version: 0,
            info: queryContext,
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        let timer = CFRunLoopTimerCreate(
            nil, /* allocator: */
            CFAbsoluteTimeGetCurrent() + timeout, /* fireDate: */
            0,  /* interval: */
            0, /* flags: */
            0,  /* order: */
            timerCallback, /* callout: */
            &timerContext /* context: */
        )
        queryContext.pointee.timer = timer
        CFRunLoopAddTimer(CFRunLoopGetMain(), timer, CFRunLoopMode.defaultMode)
        
    }
}
