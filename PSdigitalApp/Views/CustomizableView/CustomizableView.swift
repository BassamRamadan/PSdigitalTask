//
//  CustomizableView.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/2/22.
//

import UIKit


class CustomizableView: UIViewController{
    @IBOutlet var CustomizableCollection: UICollectionView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    lazy var customizableViewModel: CustomizableViewModel = {
        return CustomizableViewModel()
    }()
    
    var ComboId: Int?
    var ComboImage: String?
    var ComboName: String?
    
    lazy var spacing: CGFloat = 10
    let headerId = "headerId"
    let categorHeaderId = "categorHeaderId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomizableCollection.dataSource = self
        CustomizableCollection.collectionViewLayout = makeCollectionLayout()
        CustomizableCollection.register(HeaderCell.self, forSupplementaryViewOfKind: categorHeaderId, withReuseIdentifier: headerId)
        initViewModels()
    }
    
    private func makeCollectionLayout() -> UICollectionViewLayout {
        // 1
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0{
                return self.createOneRow(isTop: true)
            }
            if self.customizableViewModel.getSectionItemsCount(at: sectionIndex) <= 5{
                return self.createOneRow()
            }
            return self.createTwoRow()
        }
                
        // 3
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
            
        return layout
    }
    
    private func createTwoRow() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(110),
                                              heightDimension: .fractionalHeight(0.5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalHeight(1))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitem: layoutItem, count: 2)
        
        
        let horSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .estimated(240))
        let hor = NSCollectionLayoutGroup.horizontal(layoutSize: horSize, subitems: [layoutGroup])
        hor.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5)
        
        
        let layoutSection = NSCollectionLayoutSection(group: hor)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        layoutSection.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: categorHeaderId, alignment: .topLeading, absoluteOffset: .init(x: 15, y: 5))
        ]
        return layoutSection
    }
    private func createOneRow(isTop: Bool = false) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                              heightDimension: .absolute(110))
        let itemSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: isTop == true ? itemSize1 : itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(isTop == true ? 200 : 110))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        layoutSection.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: categorHeaderId, alignment: .topLeading, absoluteOffset: .init(x: 15, y: 5))
        ]
        return layoutSection
    }
    
    
    fileprivate func initViewModels(){
        customizableViewModel.itemDetails.bind { [weak self] (data) in
            DispatchQueue.main.async {
                self?.CustomizableCollection.reloadData()
            }
        }
        
        customizableViewModel.state.bind { [weak self] (state) in
            guard let self = self else{
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else{
                    return
                }
                switch state{
                case .empty,.error:
                    self.loadingIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.CustomizableCollection.alpha = 0.0
                    })
                case .loading:
                    self.loadingIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.CustomizableCollection.alpha = 0.0
                    })
                case .populated:
                    self.loadingIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.CustomizableCollection.alpha = 1
                    })
                case .none:
                    print("")
                }
            }
        }
        
        customizableViewModel.alertMessage.bind { (message) in
            guard let message = message else{
                return
            }
            DispatchQueue.main.async {
                self.present(HomeView.makeAlert(message: message), animated: true, completion: nil)
            }
        }
        customizableViewModel.getCustomizableOptions(ComboID: ComboId ?? 0)
    }
    
    @IBAction func GoBack(){
        self.dismiss(animated: true)
    }
}
extension CustomizableView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return customizableViewModel.getSectionsCount() + 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : customizableViewModel.getSectionItemsCount(at: section)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCell else { return UICollectionReusableView()}
        
        header.CategoryName.text = indexPath.section == 0 ? "" : customizableViewModel.getSectionName(at: indexPath.section)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as? ItemDetailsCell else{
                return UICollectionViewCell()
            }
            cell.name.text = ComboName ?? ""
            cell.imageView.sd_setImage(with: URL(string: (ComboImage ?? "").replacingOccurrences(of: " ", with: "%20")), completed: nil)
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customizableViewModel.getSectionIdentifier(at: indexPath.section), for: indexPath) as? ItemDetailsCell else{
                return UICollectionViewCell()
            }
            let cellvm = customizableViewModel.getCellData(at: indexPath)
            cell.name.text = cellvm.name
            if cellvm.imagePath != nil{
                cell.imageView.sd_setImage(with: URL(string: cellvm.imagePath?.replacingOccurrences(of: " ", with: "%20") ?? ""), completed: nil)
            }
            return cell
        }
    }
}
