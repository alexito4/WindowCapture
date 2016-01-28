
import RxSwift

private class Timer {
    let timer: dispatch_source_t
    
    init(interval: NSTimeInterval, queueId: Int = DISPATCH_QUEUE_PRIORITY_DEFAULT) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        dispatch_source_set_timer(timer, 0, UInt64(interval * Double(NSEC_PER_SEC)), 0)
    }
    
    func start(block: () -> ()) {
        dispatch_source_set_event_handler(timer, {
            block()
        })
        dispatch_resume(timer)
    }
    
    func stop() {
        dispatch_source_cancel(timer)
    }
    
    deinit {
        stop()
    }
}

public extension Window {
    
    /// Calls `onNext` in the same Queue as its processing queue.
    /// This means that any blocking operation in the Observable chain will
    /// block the captures.
    /// Which can be really good to automatically "throttle" the capture process.
    /// If you want to avoid this blocking behaviour just "observeOn" another scheduler.
    public func capture(interval: NSTimeInterval = 0.0) -> Observable<CGImage> {
        return Observable.create { observer in
            let timer = Timer(interval: interval)
            
            let cancel = AnonymousDisposable {
                timer.stop()
            }
            
            timer.start {
                if cancel.disposed {
                    return
                }
                
                let image: CGImage = self.capture()
                
                observer.onNext(image)
            }
            
            return cancel
        }
    }
    
}

public extension Window {
    
    public static func allWindows(interval: NSTimeInterval = 0.1) -> Observable<[Window]> {
        return Observable.create { observer in
            let timer = Timer(interval: interval)
            
            let cancel = AnonymousDisposable {
                timer.stop()
            }
            
            timer.start {
                if cancel.disposed {
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    let windows: [Window] = allWindows()
                    
                    observer.on(.Next(windows))
                }
                
            }
            
            return cancel
        }
    }
    
}