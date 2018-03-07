import UIKit
import PlaygroundSupport

public class Board {
    
    public class BoardPoint {
        let center: CGPoint
        var player: Int?
        
        init(_ center: CGPoint){
            self.center = center
        }
    }
    
    let boardView : UIView
    
    let boardViewSize   = CGSize(width: 360, height: 360)
    
    let piecesSize = 34
    
    var timeSelectLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    let timeIncrementButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
    let timeDecrementButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
    
    let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 20))
    
    var timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let timeLabelRedColor = UIColor(red: 0.9, green: 0.37, blue: 0.37, alpha: 1)
    let timeLabelYellowColor = UIColor(red: 0.96, green: 0.88, blue: 0.45, alpha: 1)
    
    
    static var timeLimit = 30
    var time = 30
    
    var running = false
    
    var timer = Timer()
    
    let stackPiecesPosition: CGPoint
    
    var currentPlayer = 1
    
    var boardPoints = [[BoardPoint]]()
    
    var inputs = [UIImageView]()
    
    var stackPieces = [UIImageView]()
    
    public init() {
        boardView = UIView(frame: .zero)
        boardView.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.1294117647, blue: 0.1843137255, alpha: 1)
        boardView.translatesAutoresizingMaskIntoConstraints = false
        
        //Creating stack pieces  position
        
        stackPiecesPosition = CGPoint(x: boardViewSize.width/2, y: 20)
        
        //Creating board background
        
        let boardBackgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 260, height: 228))
        boardBackgroundImageView.center = CGPoint(x: self.boardViewSize.width/2, y: (self.boardViewSize.height/2)+50)
        boardBackgroundImageView.image = UIImage(named: "BoardBackground.png")
        boardView.addSubview(boardBackgroundImageView)
        
        //Creating label and buttons to select time
        
        timeSelectLabel.text = "Time: \(Board.timeLimit)"
        timeSelectLabel.textColor = UIColor.white
        timeSelectLabel.center = CGPoint(x: 145, y: 35)
        boardView.addSubview(timeSelectLabel)
        
        timeIncrementButton.setTitle("+", for: .normal)
        timeIncrementButton.setTitleColor(UIColor.white, for: .normal)
        timeIncrementButton.layer.borderWidth = 1
        timeIncrementButton.layer.borderColor = UIColor.white.cgColor
        timeIncrementButton.layer.cornerRadius = 2
        timeIncrementButton.addTarget(self, action: #selector(incrementTime), for: .touchUpInside)
        timeIncrementButton.center = CGPoint(x: 160, y: 35)
        boardView.addSubview(timeIncrementButton)
        
        timeDecrementButton.setTitle("-", for: .normal)
        timeDecrementButton.setTitleColor(UIColor.white, for: .normal)
        timeDecrementButton.layer.borderWidth = 1
        timeDecrementButton.layer.borderColor = UIColor.white.cgColor
        timeDecrementButton.layer.cornerRadius = 2
        timeDecrementButton.addTarget(self, action: #selector(decrementTime), for: .touchUpInside)
        timeDecrementButton.center = CGPoint(x: 184, y: 35)
        boardView.addSubview(timeDecrementButton)
        
        //Creating button play
        
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(UIColor.white, for: .normal)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        playButton.center = CGPoint(x: 260, y: 35)
        boardView.addSubview(playButton)
        
        // Creating board points
        
        let yPointInitialPosition: Double = 310.8
        var xPointPosition: Double = 82.1
        var yPointPosition = yPointInitialPosition
        let pointDiference: Double = 32.6
        
        for _ in 0...6 {
            var boardPointsTime = [BoardPoint]()
            for _ in 0...5 {
                let point = CGPoint(x: xPointPosition, y: yPointPosition)
                let boardPoint = BoardPoint(point)
                boardPointsTime.append(boardPoint)
                
                yPointPosition -= pointDiference
            }
            boardPoints.append(boardPointsTime)
            
            xPointPosition += pointDiference
            yPointPosition = yPointInitialPosition
        }
        
        // Creating inputs
        
        let inputYPosition = 100.0
        for index in 0...6 {
            let inputXPosition = boardPoints[index][0].center.x
            
            let inputImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: piecesSize, height: piecesSize))
            inputImageView.center = CGPoint(x: Double(inputXPosition), y: inputYPosition)
            let inputImage = UIImage(named: "Input.png")
            inputImageView.image = inputImage
            boardView.addSubview(inputImageView)
            inputImageView.isHidden = true
            inputs.append(inputImageView)
        }
        
        // Creating stack pieces
        
        for index in 0...51 {
            let pieceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: piecesSize, height: piecesSize))
            pieceImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
            pieceImageView.center = stackPiecesPosition
            
            if(index%2 != 0){
                pieceImageView.image = UIImage(named: "Piece1.png")
            }
            else{
                pieceImageView.image = UIImage(named: "Piece2.png")
            }
            
            pieceImageView.isHidden = true;
            
            boardView.addSubview(pieceImageView)
            
            stackPieces.append(pieceImageView)
        }
        stackPieces[stackPieces.count-1].isUserInteractionEnabled = true
        
        // Creating board
        
        let boardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 260, height: 228))
        boardImageView.image = UIImage(named: "Board.png")
        boardImageView.center = CGPoint(x: self.boardViewSize.width/2, y: (self.boardViewSize.height/2)+50)
        boardView.addSubview(boardImageView)
        
        update()
    }
    
    @objc func incrementTime() {
        if(Board.timeLimit < 120){
            Board.timeLimit += 5
            timeSelectLabel.text = "Time: \(Board.timeLimit)"
        }
    }
    
    @objc func decrementTime() {
        if(Board.timeLimit > 10){
            Board.timeLimit -= 5
            timeSelectLabel.text = "Time: \(Board.timeLimit)"
        }
    }
    
    @objc public  func play() {
        
        timeSelectLabel.isHidden = true
        timeIncrementButton.isHidden = true
        timeDecrementButton.isHidden = true
        playButton.isHidden = true
        
        for piece in stackPieces{
            piece.isHidden = false
        }
        
        for input in inputs{
            input.isHidden = false
        }
        
        time = Board.timeLimit
        
        timeLabel.isHidden = false
        timeLabel.text = "Time: \(time)"
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: 15)
        timeLabel.textColor = timeLabelRedColor
        timeLabel.center = CGPoint(x: 120, y: 20)
        boardView.addSubview(timeLabel)
        
        running = true
    }
    
    func update(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timeUpdate(){
        if(running){
            time -= 1
            timeLabel.text = "Time: \(time)"
            if(time < 0){
                stackPieces[stackPieces.count-1].isHidden = true
                stackPieces.remove(at: stackPieces.count-1)
                if(stackPieces.count>0){
                    changePlayer()
                }
                else{
                    timeLabel.isHidden = true
                    showPlayAgainButton(withXPosition: boardViewSize.width/2, andYPosition: 55)
                }
            }
        }
    }
    
    func changePlayer(){
        currentPlayer = currentPlayer == 1 ? 2 : 1
        stackPieces[stackPieces.count-1].isUserInteractionEnabled = true
        time = Board.timeLimit
        timeLabel.text = "Time: \(time)"
        if(currentPlayer == 1){
            timeLabel.center = CGPoint(x: 120, y: 20)
            timeLabel.textColor = timeLabelRedColor
        }
        else{
            timeLabel.center = CGPoint(x: 280, y: 20)
            timeLabel.textColor = timeLabelYellowColor
        }
    }
    
    func showPlayAgainButton(withXPosition x: CGFloat, andYPosition y: CGFloat ){
        let playAgainButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        playAgainButton.center = CGPoint(x: x, y: y)
        playAgainButton.setTitle("Play again", for: .normal)
        playAgainButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        playAgainButton.setTitleColor(UIColor.white, for: .normal)
        boardView.addSubview(playAgainButton)
    }
    
    @objc public  func playAgain() {
        PlaygroundPage.current.liveView = GameViewController()
    }
    
    func movePiece(_ view:UIView, _ point: CGPoint){
        UIView.animate(withDuration: 1) {
            view.center = point
        }
    }
    
    func matchResult(boardXPoint x: Int, boardYPoint y: Int) -> Bool {
        
        var sequenceSize = 1
        var xTemp = x
        var yTemp = y
        let boardPoint = boardPoints[x][y]
        
        //Horizontal
        
        while xTemp-1>=0 {
            if(boardPoints[xTemp-1][y].player == boardPoint.player){
                sequenceSize += 1
                xTemp -= 1
            }
            else{
                break
            }
        }
        
        xTemp = x
        
        while xTemp+1 < boardPoints.count {
            if(boardPoints[xTemp+1][y].player == boardPoint.player){
                sequenceSize += 1
                xTemp += 1
            }
            else{
                break
            }
        }
        
        if(sequenceSize>=4){
            return true
        }
        
        //Vertical
        
        sequenceSize = 1
        
        while yTemp-1 >= 0 {
            if(boardPoints[x][yTemp-1].player == boardPoint.player){
                sequenceSize += 1
                yTemp -= 1
            }
            else{
                break
            }
        }
        
        if(sequenceSize>=4){
            return true
        }
        
        //Diagonal 1
        
        xTemp = x
        yTemp = y
        sequenceSize = 1
        
        while (xTemp-1 >= 0 && yTemp+1 < boardPoints[0].count) {
            if(boardPoints[xTemp-1][yTemp+1].player == boardPoint.player){
                sequenceSize += 1
                xTemp -= 1
                yTemp += 1
            }
            else{
                break
            }
        }
        
        xTemp = x
        yTemp = y
        
        while (xTemp+1 < boardPoints.count && yTemp-1 >= 0) {
            if(boardPoints[xTemp+1][yTemp-1].player == boardPoint.player){
                sequenceSize += 1
                xTemp += 1
                yTemp -= 1
            }
            else{
                break
            }
        }
        
        if(sequenceSize>=4){
            return true
        }
        
        //Diagonal 2
        
        sequenceSize = 1
        xTemp = x
        yTemp = y
        
        while (xTemp-1>=0 && yTemp-1>=0) {
            if(boardPoints[xTemp-1][yTemp-1].player == boardPoint.player){
                sequenceSize += 1
                xTemp -= 1
                yTemp -= 1
            }
            else{
                break
            }
        
        }
        xTemp = x
        yTemp = y
        
        while (xTemp+1 < boardPoints.count && yTemp+1 < boardPoints[0].count) {
            if(boardPoints[xTemp+1][yTemp+1].player == boardPoint.player){
                sequenceSize += 1
                xTemp += 1
                yTemp += 1
            }
            else{
                break
            }
        }
        
        if(sequenceSize>=4){
            return true
        }
        
        return false
    }
    
    public func addConstrants(view : UIView){
        view.addSubview(self.boardView)
        boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        boardView.widthAnchor.constraint(equalToConstant: boardViewSize.width).isActive = true
        boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor).isActive = true
    }
    
    func isBoardFull() -> Bool{
        for index in (0...6) {
            for index2 in 0...5{
                if(boardPoints[index][index2].player == nil){
                    return false
                }
            }
        }
        return true
    }
    
    @objc func handlePan(recognizer:UIPanGestureRecognizer) {
        if let pieceView = recognizer.view{
            let viewXPosition = pieceView.center.x
            let viewYPosition = pieceView.center.y
            if(recognizer.state == .ended && !pieceView.isHidden)
            {
                var moved = false
                let differenceInput = 5.0
                
                var point = self.stackPiecesPosition
                
                if (viewYPosition >= inputs[0].center.y - CGFloat(differenceInput)) {
                    
                    var index: Int?
                    
                    if(viewXPosition >= (inputs[0].center.x - CGFloat(differenceInput)) && viewXPosition <= (inputs[0].center.x + CGFloat(differenceInput))){
                        index = 0
                    }
                    else if(viewXPosition >= (inputs[1].center.x - CGFloat(differenceInput)) && viewXPosition <= (inputs[1].center.x + CGFloat(differenceInput))){
                        index = 1
                    }
                    else if(viewXPosition >= (inputs[2].center.x - CGFloat(differenceInput)) && viewXPosition <= (inputs[2].center.x + CGFloat(differenceInput))){
                        index = 2
                    }
                    else if(viewXPosition >= (inputs[3].center.x - CGFloat(differenceInput)) && viewXPosition <= (inputs[3].center.x + CGFloat(differenceInput))){
                        index = 3
                    }
                    else if(viewXPosition >= (inputs[4].center.x - CGFloat(differenceInput)) && viewXPosition <= (inputs[4].center.x + CGFloat(differenceInput))){
                        index = 4
                    }
                    else if(viewXPosition >= (inputs[5].center.x - CGFloat(differenceInput)) && viewXPosition <= (inputs[5].center.x + CGFloat(differenceInput))){
                        index = 5
                    }
                    else if(viewXPosition >= (inputs[6].center.x - CGFloat(differenceInput)) && viewXPosition <= (inputs[6].center.x + CGFloat(differenceInput))){
                        index = 6
                    }
                    
                    
                    if (index != nil) {
                        
                        for index2 in (0...5) {
                            
                            let boardPoint = boardPoints[index!][index2]
                            
                            if(boardPoint.player == nil){
                            
                                point = inputs[index!].center
                                pieceView.center = point
                                boardPoint.player = currentPlayer
                                stackPieces[stackPieces.count-1].isUserInteractionEnabled = false
                                stackPieces.remove(at: stackPieces.count-1)
                                movePiece(pieceView, boardPoint.center)
                                
                                if(matchResult(boardXPoint: index!, boardYPoint: index2)){
                                    
                                    running = false
                                    
                                    for pieceImageView in stackPieces{
                                        pieceImageView.isHidden = true
                                    }
                                    
                                    timeLabel.isHidden = true
                                    
                                    let winnerPieceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: piecesSize, height: piecesSize))
                                    winnerPieceImageView.center = CGPoint(x: 130, y: 35)
                                    
                                    if(currentPlayer == 1){
                                        winnerPieceImageView.image = UIImage(named: "Piece1.png")
                                    }
                                    else{
                                        winnerPieceImageView.image = UIImage(named: "Piece2.png")
                                    }
                                    
                                    boardView.addSubview(winnerPieceImageView)
                                    
                                    
                                    let winnerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                                    winnerImageView.center = CGPoint(x: 130, y: 45)
                                    winnerImageView.image = UIImage(named: "Winner.png")
                                    boardView.addSubview(winnerImageView)
                                    
                                    showPlayAgainButton(withXPosition: 220, andYPosition: 35)
                                }
                                else if (stackPieces.count == 0 || isBoardFull()) {
                                    timeLabel.isHidden = true
                                    showPlayAgainButton(withXPosition: boardViewSize.width/2, andYPosition: 55)
                                    running = false
                                }
                                else{
                                    changePlayer()
                                }
                                moved = true
                                
                                break
                            }
                        }
                    }
                }
                
                if !moved {
                    movePiece(pieceView, point)
                }
                
            }
            else{
                let translation = recognizer.translation(in: pieceView)
                if(viewXPosition < CGFloat(67)){
                    pieceView.center.x = 67
                }
                if(viewYPosition < CGFloat(15)){
                    pieceView.center.y = 15
                }
                if(viewXPosition > CGFloat(293)){
                    pieceView.center.x = 293
                }
                if(viewYPosition > CGFloat(100)){
                    pieceView.center.y = 100
                }
                pieceView.center = CGPoint(x:pieceView.center.x + translation.x, y:pieceView.center.y + translation.y)
            }
            
            recognizer.setTranslation(CGPoint.zero, in: pieceView)
            
        }
    }
}












