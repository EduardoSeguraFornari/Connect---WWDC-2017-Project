import UIKit

public class GameViewController : UIViewController {
    let board = Board()
    override public func viewDidLoad() {
        if let view = self.view {
            view.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.1294117647, blue: 0.1843137255, alpha: 1)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            board.addConstrants(view: view)
        }
    }
}

