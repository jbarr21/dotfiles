//
import Cocoa
let pb = NSPasteboard.general

if let string = pb.string(forType: NSPasteboard.PasteboardType.string) {
  pb.declareTypes([NSPasteboard.PasteboardType.html], owner: nil)
  pb.setString(string, forType: NSPasteboard.PasteboardType.html)
} else {
  print("Could not read string data from pasteboard")
  exit(1)
}
