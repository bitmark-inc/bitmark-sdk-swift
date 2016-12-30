//
//  Job.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/30/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

internal struct Job {
    
    var excutionHandler: (((() -> Void)?) -> Void)
    
}

internal class JobQueue {
    var queue = [Job]()
    private var isExcuting = false
    private var excutedPreHandler = false
    
    var jobStartHandler: (((() -> Void)?) -> Void)?
    var jobFinishHandler: (() -> Void)?
    
    public func enqueue(job: Job) {
        queue.append(job)
        excuteQueue()
    }
    
    public func dequeue() -> Job? {
        if queue.isEmpty {
            return nil
        }
        return queue.removeFirst()
    }
    
    public func excuteQueue() {
        if !self.isExcuting {
            self.isExcuting = true
            excute()
        }
    }
    
    private func excute() {
        
        let handler = { [unowned self] in
            
            if let job = self.dequeue() {
                
                
                print("Excute next tasks")
                job.excutionHandler({ [weak self] in
                    self?.excute()
                })
            }
            else {
                print("No remaining jobs, quiting ...")
                self.isExcuting = false
                self.jobFinishHandler?()
            }
        }
        
        if excutedPreHandler {
            handler()
        }
        else {
            // Excute start handler and wait for it to finish
            jobStartHandler?({ [unowned self] in
                self.excutedPreHandler = true
                handler()
            })
        }
    }
    
}
