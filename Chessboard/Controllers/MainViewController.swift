//
//  MainViewController.swift
//  Chessboard
//
//  Copyright © 2019 Kleanthis Gkergki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var chessboardCollectionView: UICollectionView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    var data: [[Data]] = []
    var possibleMoves: [Position] = []
    var results: [String] = []
    
    var boardSize = 8
    
    let numberOfMoves = 3
    
    var isStartingPositionSelected = false
    var isEndingPositionSelected = false
    
    var startingPosition: Position?
    var endingPosition: Position?
    
    var startingPositionColor = UIColor.blue
    var endingPositionColor = UIColor.red
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chessboardCollectionView.delegate = self
        chessboardCollectionView.dataSource = self
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        chessboardCollectionView.allowsMultipleSelection = true
        resultsTableView.isHidden = true
        
        setUpText()
        
        addCollectionViewBorder()
        
        registerCustomCells()
        
        initializeData()
        initializeMoves()
    }
    
    func initializeData() {
        let firstLetter = Int(("a" as UnicodeScalar).value)
        var color = UIColor.white
        for i in 0 ..< boardSize {
            var d: [Data] = []
            for j in 0 ..< boardSize {
                guard let c = UnicodeScalar(j + firstLetter) else {
                    return
                }
                d.append(Data(name: "\(Character(c))\(boardSize - i)", color: color))
                color = changeTileColor(color: color)
            }
            data.append(d)
            if boardSize % 2 == 0 {
                color = changeTileColor(color: color)
            }
        }
    }
    
    func initializeMoves() {
        possibleMoves = [Position(x: -2, y: -1),
                Position(x: -2, y:  1),
                Position(x: -1, y: -2),
                Position(x: -1, y:  2),
                Position(x:  1, y: -2),
                Position(x:  1, y:  2),
                Position(x:  2, y: -1),
                Position(x:  2, y:  1),
        ]
    }
    
    func changeTileColor(color: UIColor) -> UIColor {
        var newColor = UIColor.clear
        if color == UIColor.black {
            newColor = UIColor.white
        }
        else if color == UIColor.white{
            newColor = UIColor.black
        }
        return newColor
    }
    
    func setUpText() {
        let attributedString = NSMutableAttributedString(string:
            "Pick 2 tiles to mark a starting position and an ending position for the knight")
        attributedString.addAttribute(.foregroundColor, value: startingPositionColor,
                                      range: NSRange(location: 23, length: 17))
        attributedString.addAttribute(.foregroundColor, value: endingPositionColor,
                                      range: NSRange(location: 48, length: 15))
        textLabel.attributedText = attributedString
    }
    
    func addCollectionViewBorder() {
        chessboardCollectionView.layer.borderWidth = 1
        chessboardCollectionView.layer.borderColor = UIColor.black.cgColor
    }
    
    func registerCustomCells() {
        let nib1 = UINib(nibName: "TileCollectionViewCell", bundle: nil)
        chessboardCollectionView.register(nib1, forCellWithReuseIdentifier: "tileCell")
        let nib2 = UINib(nibName: "ResultTableViewCell", bundle: nil)
        resultsTableView.register(nib2, forCellReuseIdentifier: "resultCell")
    }
    
    func findPaths() {
        guard let start = startingPosition, let end = endingPosition else {
            return
        }
        var success = false
        
        var firstMove = start
        var secondMove = start
        var thirdMove = start
        for move1 in possibleMoves {
            firstMove = nextMove(prev: start, move: move1)
            if !isMoveValid(position: firstMove) {
                continue
            }
            for move2 in possibleMoves {
                secondMove = nextMove(prev: firstMove, move: move2)
                if !isMoveValid(position: secondMove) || secondMove.isEqual(to: start) {
                    continue
                }
                for move3 in possibleMoves {
                    thirdMove = nextMove(prev: secondMove, move: move3)
                    if !isMoveValid(position: thirdMove) || thirdMove.isEqual(to: firstMove) {
                        continue
                    }
                    if thirdMove.isEqual(to: end) {
                        success = true
                        guard let begin = data[start.x][start.y].name,
                            let first = data[firstMove.x][firstMove.y].name,
                            let second = data[secondMove.x][secondMove.y].name,
                            let third = data[thirdMove.x][thirdMove.y].name
                            else {
                                return
                        }
                        results.append("\(begin) -> \(first) -> \(second) -> \(third)")
                    }
                }
            }
        }
        if success {
            resultsTableView.reloadData()
            resultsTableView.isHidden = false
        }
        else {
            tryAgain()
        }
    }
    
    func nextMove(prev: Position, move: Position) -> Position {
        var next = Position(x: 0, y: 0)
        next.x = prev.x + move.x
        next.y = prev.y + move.y
        return next
    }
    
    func tryAgain() {
        let alert = UIAlertController(title: "No solutions found",
                                      message: """
                                            There are no paths where the knight can get from the starting position
                                            to the ending position in \(numberOfMoves) moves
                                            """,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { action in
            self.reset()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func isMoveValid(position: Position) -> Bool {
        if position.x >= 0 && position.y >= 0 && position.x < boardSize && position.y < boardSize {
            return true
        }
        return false
    }
    
    func reset() {
        isStartingPositionSelected = false
        isEndingPositionSelected = false
        chessboardCollectionView.reloadData()
        results.removeAll()
        resultsTableView.reloadData()
        resultsTableView.isHidden = true
    }
    
    @IBAction func resetBoard(_ sender: UIButton) {
        reset()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let d = data[indexPath.section][indexPath.row]
        let chessCell = chessboardCollectionView.dequeueReusableCell(withReuseIdentifier: "tileCell", for: indexPath)
            as! TileCollectionViewCell
        chessCell.tileNameLabel.text = d.name
        chessCell.backgroundColor = d.color
        chessCell.tileNameLabel.textColor = UIColor.gray
        return chessCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chessCell = chessboardCollectionView.cellForItem(at: indexPath) as! TileCollectionViewCell
        if !isStartingPositionSelected {
            isStartingPositionSelected = true
            startingPosition = Position(x: indexPath.section, y: indexPath.row)
            chessCell.tileNameLabel.textColor = startingPositionColor
        } else if !isEndingPositionSelected {
            isEndingPositionSelected = true
            endingPosition = Position(x: indexPath.section, y: indexPath.row)
            chessCell.tileNameLabel.textColor = endingPositionColor
            findPaths()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return boardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if boardSize == 0 {
            boardSize = 8
        }
        return CGSize(width: chessboardCollectionView.frame.width / CGFloat(boardSize),
                      height: chessboardCollectionView.frame.height / CGFloat(boardSize))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results[indexPath.row]
        let resultCell = resultsTableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            as! ResultTableViewCell
        resultCell.resultextLabel.text = result
        return resultCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Paths"
    }
    
}
