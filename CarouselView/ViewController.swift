//
//  ViewController.swift
//  CarouselView
//
//  Created by Gagan Vishal on 02/04/18.
//  Copyright © 2018 Gagan Vishal. All rights reserved.
//

import UIKit

let cellIdentifier = "cardActionDetail"
class ViewController: UIViewController {
    // a table object to show opertaion on swiped card
    @IBOutlet weak var actionDetailTableView: UITableView!
    //collectionview used to display cards in CarouselView
    @IBOutlet weak var collectionView: UICollectionView!
 //
    @IBOutlet weak var scrollViewWidthContraint: NSLayoutConstraint!
    //display active index
    @IBOutlet weak var pageControl: UIPageControl!
    //scroll view to swipe cards
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    /*-------------------Constants used in carousal view forming--------------*/
    let verticalInset = CGFloat(10)
    let spaceBetweenCells = CGFloat(10)
    var horizontalInset = CGFloat()
    var cellWidth = CGFloat()
    /*-------------------Constants used in carousal view forming--------------*/
    //number of items to display. You can change it from any array data coming from sever/local databae
    var itemsToDisplay = 4
    //an index where we need to show selected page. You can change it but should be in range
   var selectedCardIndex = 0
    
    //array to display action on selected cell
    var arrayOfselctedCardOperations = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up Carousel
        self.prepareCollectionView()
        self.pageControl.numberOfPages = self.itemsToDisplay
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.prepareScrollView()
    }

}

//MARK: - PREPARING SUBVIEWS
extension ViewController {
    
    func prepareCollectionView() {
        self.collectionView.reloadData()
    }
    
    func prepareScrollView() {
        self.collectionView.scrollToItem(at: IndexPath(item: selectedCardIndex, section: 0), at: .centeredHorizontally, animated: false)
        self.pageControl.currentPage = self.selectedCardIndex
        self.scrollViewWidthContraint.constant = self.cellWidth + spaceBetweenCells
        self.containerScrollView.contentSize.width = (self.cellWidth + self.spaceBetweenCells) * CGFloat(itemsToDisplay)
        self.containerScrollView.contentOffset = CGPoint(x: 240.0*Double(selectedCardIndex) + Double(spaceBetweenCells*CGFloat(selectedCardIndex)), y: 140.0)
    }
}

//MARK:- UItableView delegate
extension ViewController : UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

//MAKR:- UITableView Datasource
extension ViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfselctedCardOperations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Operation for card index:- " + "\(arrayOfselctedCardOperations[indexPath.row])"
        return cell
    }
}

//MARK: - COLLECTION VIEW DATA SOURCE
extension ViewController: UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsToDisplay
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CollectionViewCell
             cell.cardTileView.cardNameLabel.text = "viewModel.fullName"
            cell.cardTileView.cardStatusLabel.text = "viewModel.cardStatusValue"
            cell.cardTileView.cardNumberLabel.text = "viewModel.cardNumnerMasked"
           return cell
    }
}

//MARK: - CUSTOMIZING COLLECTION VIEW FLOW LAYOUT
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.spaceBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        self.cellWidth = 240.0
        self.horizontalInset = (self.collectionView.frame.width - self.cellWidth) / 2
        return CGSize(width: self.cellWidth, height: 140.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        return UIEdgeInsets(top: layout.sectionInset.top, left: self.horizontalInset, bottom: layout.sectionInset.top, right: self.horizontalInset)
    }
}

//MARK: - CUSTOMIZING SCROLL VIEW
extension ViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView || scrollView == self.containerScrollView {
            self.collectionView.contentOffset.x = scrollView.contentOffset.x
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.collectionView || scrollView == self.containerScrollView {
            if let selected = self.collectionView.indexPathForItem(at: CGPoint(x: targetContentOffset.pointee.x + self.collectionView.frame.width / 2, y: self.collectionView.frame.height / 2)) {
                self.collectionView.selectItem(at: NSIndexPath(item: selected.item, section: 0) as IndexPath, animated: false, scrollPosition: [])
                self.pageControl.currentPage = selected.item
                //re-initalize array here
                arrayOfselctedCardOperations = []
                arrayOfselctedCardOperations.append("\(selected.item)")
                //reload table here
                DispatchQueue.main.async {
                    self.actionDetailTableView.reloadData()
                }
/*-------------------- An example for card operations --------------------------------*/
                //Reload table on page selection.
//                switch viewModel.cardCells.value[selected.item] {
//                case .normal(let viewModel):
//                    self.selectedCardItem = viewModel.cardItem
//                    print("items are :\(self.selectedCardItem.cardOperations)")
//                    //Reload table here for a new data dispaly on card selection
//                    DispatchQueue.main.async { [weak self] in
//                        self?.cardActionTableView.reloadData()
//                        self?.actionDetailTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//                    }
//                case .error(let message):
//                    print("message is :\(message)")
//                case .empty:
//                    print("No Record to show")
//                }
 /*-------------------- An example for card operations --------------------------------*/

            }
        }
    }
}
