
import AppKit

class ImageViewController: NSViewController {
    
    @IBOutlet private weak var imageView: NSImageView!
    
    var image: NSImage? {
        didSet {
            imageView.image = image
        }
    }
}