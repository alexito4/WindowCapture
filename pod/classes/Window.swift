
import Quartz

public struct Window {
    
    public struct Owner {
        public let name: String
        public let PID: Int
    }
    
    public let alpha: Double
    public let bounds: CGRect
    public let layer: Int
    public let memoryUsage: Int64
    public let name: String
    public let number: Int
    public let owner: Owner
    public let sharingState: Int
    public let store: CGWindowBackingType
    
    // Init from a Dictionary coming from `CGWindowListCopyWindowInfo`
    // Quartz API should be stable enough by now that if some of our expectations fail
    // we should fail straightaway and debug what is going on.
    public init(dic: NSDictionary) {
        self.alpha = dic[kCGWindowAlpha as String] as! Double
        
        var rect = CGRect()
        CGRectMakeWithDictionaryRepresentation(dic[kCGWindowBounds as String] as! NSDictionary, &rect)
        self.bounds = rect
        
        self.layer = dic[kCGWindowLayer as String] as! Int
        
        self.memoryUsage = dic[kCGWindowMemoryUsage as String] as? Int64 ?? 0
        
        self.name = (dic[kCGWindowName as String] as? String) ?? ""
        self.number = dic[kCGWindowNumber as String] as! Int
        
        let ownerName = dic[kCGWindowOwnerName as String] as! String
        let ownerPID = dic[kCGWindowOwnerPID as String] as! Int
        self.owner = Owner(name: ownerName, PID: ownerPID)
        
        self.sharingState = dic[kCGWindowSharingState as String] as! Int
        
        let storeRaw = dic[kCGWindowStoreType as String] as! Int
        self.store = CGWindowBackingType(rawValue: UInt32(storeRaw))!
    }
    
    public func capture() -> CGImage {
        let image = CGWindowListCreateImage(
            CGRect.null,
            CGWindowListOption.OptionIncludingWindow,
            UInt32(self.number),
            [.BestResolution, .BoundsIgnoreFraming]
        )
        return image!
    }
}

public extension Window {
    
    public typealias Filter = (input: Window) -> Bool
    
    public static func basicFilter(input: Window) -> Bool {
        return
            input.name != "" &&
            input.name != "Focus Proxy"
    }
    
    public static func allWindows(listOption: CGWindowListOption = .OptionOnScreenOnly, filter: Filter = Window.basicFilter) -> [Window] {
        let info: NSArray = CGWindowListCopyWindowInfo(listOption, 0)!
        return info.map({ Window(dic: $0 as! NSDictionary) }).filter(filter)
    }
}
