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
        
        data = initializeData()
        possibleMoves = initializeMoves()
    }
    
    func initializeData() -> [[Data]] {
        return [[Data(name: "a8", selected: false, color: UIColor.white),
                 Data(name: "b8", selected: false, color: UIColor.black),
                 Data(name: "c8", selected: false, color: UIColor.white),
                 Data(name: "d8", selected: false, color: UIColor.black),
                 Data(name: "e8", selected: false, color: UIColor.white),
                 Data(name: "f8", selected: false, color: UIColor.black),
                 Data(name: "g8", selected: false, color: UIColor.white),
                 Data(name: "h8", selected: false, color: UIColor.black)],
                [Data(name: "a7", selected: false, color: UIColor.black),
                 Data(name: "b7", selected: false, color: UIColor.white),
                 Data(name: "c7", selected: false, color: UIColor.black),
                 Data(name: "d7", selected: false, color: UIColor.white),
                 Data(name: "e7", selected: false, color: UIColor.black),
                 Data(name: "f7", selected: false, color: UIColor.white),
                 Data(name: "g7", selected: false, color: UIColor.black),
                 Data(name: "h7", selected: false, color: UIColor.white)],
                [Data(name: "a6", selected: false, color: UIColor.white),
                 Data(name: "b6", selected: false, color: UIColor.black),
                 Data(name: "c6", selected: false, color: UIColor.white),
                 Data(name: "d6", selected: false, color: UIColor.black),
                 Data(name: "e6", selected: false, color: UIColor.white),
                 Data(name: "f6", selected: false, color: UIColor.black),
                 Data(name: "g6", selected: false, color: UIColor.white),
                 Data(name: "h6", selected: false, color: UIColor.black)],
                [Data(name: "a5", selected: false, color: UIColor.black),
                 Data(name: "b5", selected: false, color: UIColor.white),
                 Data(name: "c5", selected: false, color: UIColor.black),
                 Data(name: "d5", selected: false, color: UIColor.white),
                 Data(name: "e5", selected: false, color: UIColor.black),
                 Data(name: "f5", selected: false, color: UIColor.white),
                 Data(name: "g5", selected: false, color: UIColor.black),
                 Data(name: "h5", selected: false, color: UIColor.white)],
                [Data(name: "a4", selected: false, color: UIColor.white),
                 Data(name: "b4", selected: false, color: UIColor.black),
                 Data(name: "c4", selected: false, color: UIColor.white),
                 Data(name: "d4", selected: false, color: UIColor.black),
                 Data(name: "e4", selected: false, color: UIColor.white),
                 Data(name: "f4", selected: false, color: UIColor.black),
                 Data(name: "g4", selected: false, color: UIColor.white),
                 Data(name: "h4", selected: false, color: UIColor.black)],
                [Data(name: "a3", selected: false, color: UIColor.black),
                 Data(name: "b3", selected: false, color: UIColor.white),
                 Data(name: "c3", selected: false, color: UIColor.black),
                 Data(name: "d3", selected: false, color: UIColor.white),
                 Data(name: "e3", selected: false, color: UIColor.black),
                 Data(name: "f3", selected: false, color: UIColor.white),
                 Data(name: "g3", selected: false, color: UIColor.black),
                 Data(name: "h3", selected: false, color: UIColor.white)],
                [Data(name: "a2", selected: false, color: UIColor.white),
                 Data(name: "b2", selected: false, color: UIColor.black),
                 Data(name: "c2", selected: false, color: UIColor.white),
                 Data(name: "d2", selected: false, color: UIColor.black),
                 Data(name: "e2", selected: false, color: UIColor.white),
                 Data(name: "f2", selected: false, color: UIColor.black),
                 Data(name: "g2", selected: false, color: UIColor.white),
                 Data(name: "h2", selected: false, color: UIColor.black)],
                [Data(name: "a1", selected: false, color: UIColor.black),
                 Data(name: "b1", selected: false, color: UIColor.white),
                 Data(name: "c1", selected: false, color: UIColor.black),
                 Data(name: "d1", selected: false, color: UIColor.white),
                 Data(name: "e1", selected: false, color: UIColor.black),
                 Data(name: "f1", selected: false, color: UIColor.white),
                 Data(name: "g1", selected: false, color: UIColor.black),
                 Data(name: "h1", selected: false, color: UIColor.white)],
        ]
    }
    
    func initializeMoves() -> [Position] {
        return [Position(x: -2, y: -1),
                Position(x: -2, y:  1),
                Position(x: -1, y: -2),
                Position(x: -1, y:  2),
                Position(x:  1, y: -2),
                Position(x:  1, y:  2),
                Position(x:  2, y: -1),
                Position(x:  2, y:  1),
        ]
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
                if !isMoveValid(position: secondMove) || areEqual(first: secondMove, second: start) {
                    continue
                }
                for move3 in possibleMoves {
                    thirdMove = nextMove(prev: secondMove, move: move3)
                    if !isMoveValid(position: thirdMove) || areEqual(first: thirdMove, second: firstMove){
                        continue
                    }
                    if areEqual(first: thirdMove, second: end) {
                        success = true
                        guard let begin = data[start.x][start.y].name,
                            let first = data[firstMove.x][firstMove.y].name,
                            let second = data[secondMove.x][secondMove.y].name,
                            let third = data[thirdMove.x][thirdMove.y].name
                            else {
                                return
                        }
                        results.append("\(begin) ~> \(first) ~> \(second) ~> \(third)")
                    }
                }
            }
        }
        if success {
            print(results)
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
    
    func areEqual(first: Position, second: Position) -> Bool {
        if first.x == second.x && first.y == second.y {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
