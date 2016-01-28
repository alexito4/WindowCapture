
import AppKit

class WindowsListViewController : NSViewController {
    
    @IBOutlet private weak var tableView: NSTableView!
    
    var windows: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var windowDidChange: ((window: Int) -> ())?
}

extension WindowsListViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return windows.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return windows[row]
    }
}

extension WindowsListViewController: NSTableViewDelegate {
    func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
        
        if proposedSelectionIndexes.count > 0 {
            let index = proposedSelectionIndexes.firstIndex
            windowDidChange?(window: index)
        }
        
        return proposedSelectionIndexes
    }
}