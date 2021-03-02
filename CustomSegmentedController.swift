//
//  CustomSegmentedController.swift
//  iGap
//
//  Created by ahmad mohammadi on 10/19/20.
//

import UIKit

class CustomSegmentedController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var tabs: [String]
    private var controllers: [UIViewController]
    
    private var topViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topCollectionCellIdentifier = "topCollectionCellIdentifier"
    private var topViewCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let containerCollectionCellIdentifier = "containerCollectionCellIdentifier"
    
    private var containerCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private var bottomBarView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var mainTitle: String?
    private var selectedTab: Int = 0
    
    init(title: String = "", backColor: UIColor = .clear, lineColor: UIColor = .red, tabsTitle: [String], controllers: [UIViewController], selectedTab: Int = 0) {
        self.mainTitle = title
        self.tabs = tabsTitle
        self.controllers = controllers
        super.init(nibName: nil, bundle: nil)
        super.viewDidLoad()
        
        if tabs.count != controllers.count {
            assertionFailure("Number of tabs and controllers in CustomSegmentedController must be equal !!")
        }
        
        if selectedTab >= tabs.count {
            assertionFailure("Invalid selectedTab")
        }
        
        view.backgroundColor = backColor
        bottomBarView.backgroundColor = lineColor
        
        initView()
        self.selectedTab = selectedTab
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerCollection.scrollToItem(at: IndexPath(item: selectedTab, section: 0), at: .centeredHorizontally, animated: true)
        topViewCollection.scrollToItem(at: IndexPath(item: selectedTab, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private var bottomBarLeftAnchor : NSLayoutConstraint!
    
    private let topCollectionHeight: CGFloat = 47
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        
        view.addSubview(topViewContainer)
        
        NSLayoutConstraint.activate([topViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     topViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     topViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
                                     topViewContainer.heightAnchor.constraint(equalToConstant: topCollectionHeight + 8)
        ])
        
        
        topViewCollection.delegate = self
        topViewCollection.dataSource = self
        topViewCollection.register(TopBarCollectionCell.self, forCellWithReuseIdentifier: topCollectionCellIdentifier)
        
        topViewContainer.addSubview(topViewCollection)
        
        NSLayoutConstraint.activate([topViewCollection.bottomAnchor.constraint(equalTo: topViewContainer.bottomAnchor),
                                     topViewCollection.heightAnchor.constraint(equalToConstant: topCollectionHeight),
                                     topViewCollection.leadingAnchor.constraint(equalTo: topViewContainer.leadingAnchor),
                                     topViewCollection.trailingAnchor.constraint(equalTo: topViewContainer.trailingAnchor)
        ])
        
        topViewContainer.addSubview(bottomBarView)
        
        NSLayoutConstraint.activate([bottomBarView.bottomAnchor.constraint(equalTo: topViewContainer.bottomAnchor),
                                     bottomBarView.heightAnchor.constraint(equalToConstant: 3),
                                     bottomBarView.widthAnchor.constraint(equalToConstant: view.frame.width / CGFloat(tabs.count))
        ])
        
        bottomBarLeftAnchor = bottomBarView.leftAnchor.constraint(equalTo: topViewContainer.leftAnchor)
        bottomBarLeftAnchor.isActive = true
        
        containerCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: containerCollectionCellIdentifier)
        
        view.addSubview(containerCollection)
        
        NSLayoutConstraint.activate([containerCollection.topAnchor.constraint(equalTo: topViewContainer.bottomAnchor),
                                     containerCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     containerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     containerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        containerCollection.layoutIfNeeded()
        
        containerCollection.delegate = self
        containerCollection.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topViewCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topCollectionCellIdentifier, for: indexPath) as! TopBarCollectionCell
            cell.titleLbl.text = tabs[indexPath.row]
            return cell

        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: containerCollectionCellIdentifier, for: indexPath)
            
            let vcItem = controllers[indexPath.row]
            if !children.contains(vcItem) {
                addChild(vcItem)
                vcItem.view.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(vcItem.view)
                NSLayoutConstraint.activate(
                    [vcItem.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                     vcItem.view.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                     vcItem.view.topAnchor.constraint(equalTo: cell.topAnchor),
                     vcItem.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
                ])
                vcItem.didMove(toParent: self)
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topViewCollection {
            return CGSize(width: view.frame.width / CGFloat(tabs.count), height: topCollectionHeight)
        }else {
            return CGSize(width: containerCollection.frame.width, height: containerCollection.frame.height)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomBarLeftAnchor.constant = scrollView.contentOffset.x / CGFloat(tabs.count)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == containerCollection {
            
            let index = targetContentOffset.pointee.x / view.frame.width
            let indexPath = IndexPath(item: Int(index), section: 0)
            
            topViewCollection.selectItem(at: indexPath, animated: true, scrollPosition: [])
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == topViewCollection) {
            containerCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.view.endEditing(true)
        }
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


    //MARK: - TopBarCollectionCell
fileprivate class TopBarCollectionCell: UICollectionViewCell {
    
    var titleLbl : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .red
        lbl.adjustsFontSizeToFitWidth = true
        lbl.baselineAdjustment = .alignCenters
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLbl.topAnchor.constraint(equalTo: topAnchor),
            titleLbl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
}
