//
//  ExpandViewController.swift
//  ShroomRoom
//
//  Created by Indrajit Chavan on 17/05/19.
//  Copyright © 2019 Indrajit Chavan. All rights reserved.
//

import UIKit
import expanding_collection
import Firebase
import FirebaseDatabase

class ExpandViewController: ExpandingViewController {
    
    var classifyLabel: String?
    var imageLabel: UIImage?
        
    typealias ItemInfo = (imageName: String, title: String)
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate let items: [ItemInfo] = [("", "")]
    
//    @IBOutlet var pageLabel: UILabel!
    
    @IBAction func backToRoot(_ sender: UIButton) {
        
    }
}

extension ExpandViewController {
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 460)
        super.viewDidLoad()
        
        registerCell()
        fillCellIsOpenArray()
        addGesture(to: collectionView!)
        configureNavBar()
    }
}

// MARK: Helpers
extension ExpandViewController {
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: ExpandCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: ExpandCollectionViewCell.self))
    }
    
    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: items.count)
    }
    
//    fileprivate func getViewController() -> ExpandingTableViewController {
//        let storyboard = UIStoryboard(storyboard: .Main)
//        let toViewController: TableViewController = storyboard.instantiateViewController()
//        return toViewController
//    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(.alwaysOriginal)
    }
}

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}

/// MARK: Gesture
extension ExpandViewController {
    
    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(ExpandViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(ExpandViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? ExpandCollectionViewCell else { return }
        // double swipe Up transition
//        if cell.isOpened == true && sender.direction == .up {
//            pushToViewController(getViewController())
//
//            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
//                rightButton.animationSelected(true)
//            }
//        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}

// MARK: UIScrollViewDelegate
//extension ExpandViewController {
//
//    func scrollViewDidScroll(_: UIScrollView) {
//        pageLabel.text = "\(currentIndex + 1)/\(items.count)"
//    }
//}

// MARK: UICollectionViewDataSource
extension ExpandViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? ExpandCollectionViewCell else { return }
        
        let storage = Storage.storage().reference()
        let imageReference = storage.child("images/\(classifyLabel!.capitalized).jpg")
        //        let imageReference = storage.child("images/background.jpg")
        
        imageReference.getData(maxSize: 5*1000*1000) { (data, error) in
            if error == nil {
                self.imageLabel = UIImage(data: data!)
                cell.backgroundImageView.image = self.imageLabel
                print("Data fetched sucessfully!")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        cell.customTitle.text = self.classifyLabel?.capitalized
//        let index = indexPath.row % items.count
//        let info = items[index]
//        cell.backgroundImageView?.image = UIImage(named: info.imageName)
//        cell.customTitle.text = info.title
//        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ExpandCollectionViewCell
            , currentIndex == indexPath.row else { return }
        
//        if cell.isOpened == false {
//            cell.cellIsOpen(true)
//        } else {
////            pushToViewController(getViewController())
////
////            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
////                rightButton.animationSelected(true)
////            }
//        }
        cell.cellIsOpen(true)
    }
}

// MARK: UICollectionViewDataSource
extension ExpandViewController {
    
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ExpandCollectionViewCell.self), for: indexPath)
    }
}
