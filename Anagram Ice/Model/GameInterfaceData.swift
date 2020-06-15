//
//  GameInterfaceData.swift
//  Anagram Ice
//
//  Created by Anthony_Kasper on 6/4/20.
//  Copyright © 2020 FirstTry. All rights reserved.
//

import Foundation

struct WordBank {
    static let five:[String] = ["PLANS", "LEANS", "SATED", "MAGIC", "MINCE", "LOVED", "FIXED", "DELVE", "DIMES", "SMITE", "SMOTE", "ORDER", "ADAGE"]
    static let six:[String] = ["POURED", "MILKED", "MOVIES", "DENTED", "OPTION", "VOTERS", "TROOPS", "INCHES", "MUTINY", "GORGED", "PLUMES", "MARKED", "QUESTS", "EMBARK"]
    static let seven:[String] = ["DOUBTED", "ENDEBTS", "BLANKET", "DIVULGE", "OPTIONS", "LEAGUES", "RAPIERS", "INCLINE", "HOGWASH", "PICTURE", "STUDENT", "MORONIC", "EXPANSE", "UNDOERS", "DESTINY"]
}

public class Node {
    var value:String
    var next: Node?
    weak var previous: Node?
    
    public init(value: String) {
        self.value = value
    }
}

public class LinkedList {
    
    private var head: Node?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node? {
        return head
    }
    
    public var last: Node? {
        guard var node = head else {
            return nil
        }
        while let next = node.next {
            node = next
        }
        return node
    }
    
    public func append(value: String) {
        let newNode = Node(value: value)
        if self.isEmpty == true {
            head = newNode
        }
        else { // find the last node and append the newNode onto its end
            let finalNode = self.last!
            finalNode.next = newNode
            newNode.previous = finalNode
        }
        
    }
    
    public var count: Int {
        
        if self.isEmpty == true {
            return 0
        }
        else {
            var node = head
            var count = 1
            while let next = node!.next {
              node = next
              count += 1
            }
            return count
        }
    }
    
    public func node(atIndex index: Int) -> Node {
        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                if node == nil { //(*1)
                    break
                }
            }
            return node!
        }
    }
    
    public func remove(node: Node) -> String {
        let previousNode = node.previous
        let nextNode = node.next

        if let previousNode = previousNode {
            previousNode.next = nextNode
        } else {
            head = nextNode
        }
        nextNode?.previous = previousNode

        node.previous = nil
        node.next = nil
        return node.value
    }
    
    public func removeAt(_ index: Int) -> String {
        let nodeToRemove = node(atIndex: index)
        return remove(node: nodeToRemove)
    }
}

@objcMembers class Game {
    static var score = 0
    static var roundNumber = 0
    static var wordLength:Int = 0
}

struct Round {
    var rightAnswer:String = ""
    var topLetterPos = 0
    var guess = ""
    
    func getWordLength() -> Int {
        return rightAnswer.count
    }
    
    mutating func reset() {
        rightAnswer = ""
        topLetterPos = 0
        guess = ""
    }
}

struct Account {
    static var displayName = ""
    static var friendsList:[String] = []
}
