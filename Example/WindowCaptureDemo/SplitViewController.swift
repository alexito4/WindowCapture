
import AppKit
import RxSwift
import WindowCapture

class SplitViewController: NSSplitViewController {
    
    var listVC: WindowsListViewController!
    var imageVC: ImageViewController!
    
    var windowsBag = DisposeBag()
    var captureBag = DisposeBag()
    
    var windows: [Window] = [] {
        didSet {
            listVC.windows = windows.map({String("\($0.owner.name): \($0.name)")})
        }
    }
    
    override func viewDidLoad() {
        precondition(splitViewItems.count == 2)
        precondition(splitViewItems[0].viewController is WindowsListViewController)
        precondition(splitViewItems[1].viewController is ImageViewController)
        
        super.viewDidLoad()
        
        listVC = splitViewItems[0].viewController as! WindowsListViewController
        imageVC = splitViewItems[1].viewController as! ImageViewController
        
        // Setup Window captures
        listVC.windowDidChange = {[weak self] index in
            guard let this = self else { return }
            
            // Clear the current displayed image.
            this.imageVC.image = nil
            
            let window = this.windows[index]
            print(window)
            
            let obs: Observable<NSImage> = window.capture() // Don't change scheduler
                .map { cgImage in
                    sleep(1) // simulate intensive task
                    return NSImage(
                        CGImage: cgImage,
                        size: NSSize(
                            width: CGImageGetWidth(cgImage),
                            height: CGImageGetHeight(cgImage)
                        )
                    )
            }
            
            // Create a new DisposeBag so the previous Capture observable is disposed.
            this.captureBag = DisposeBag()
            
            let disposable = obs
                .observeOn(MainScheduler.instance)
                .subscribeNext { image in
                    this.imageVC.image = image
            }
            this.captureBag.addDisposable(disposable)
        }
        
        // Setup Windows list
        
        let disposable =
        Window.allWindows()
            .map { $0.sort({$0.owner.name < $1.owner.name}) }
            .observeOn(MainScheduler.instance)
            .subscribeNext { newWindows in
                self.windows = newWindows
        }
        windowsBag.addDisposable(disposable)
    }
    
}









