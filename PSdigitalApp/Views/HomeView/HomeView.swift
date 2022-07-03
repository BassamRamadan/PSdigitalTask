//
//  HomeView.swift
//  PSdigitalApp
//
//  Created by Bassam on 6/30/22.
//

import UIKit
import SDWebImage
class HomeView: UIViewController {
    

    @IBOutlet var CategoriesCollectionView: UICollectionView!
    @IBOutlet var ItemsCollectionView: UICollectionView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    lazy var homeViewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    lazy var spacing:CGFloat = 15
    lazy var leadingAndTrailing:CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionViews()
        initViewModels()
    }
    
    fileprivate func setCollectionViews(){
        CategoriesCollectionView.delegate = self
        CategoriesCollectionView.dataSource = self
        ItemsCollectionView.delegate = self
        ItemsCollectionView.dataSource = self
        
    }
    
    fileprivate func initViewModels(){
        homeViewModel.Categories.bind { [weak self] (data) in
            DispatchQueue.main.async {
                self?.CategoriesCollectionView.reloadData()
                self?.homeViewModel.getCategoryItems(categoryId: data?[0].id ?? 0) // get Items
            }
        }
        homeViewModel.CategoryItems.bind { [weak self] (data) in
            DispatchQueue.main.async {
                self?.ItemsCollectionView.reloadData()
                self?.ItemsCollectionView.setContentOffset(CGPoint.zero, animated: true) // reset Scroll Position To Top
            }
        }
        
        homeViewModel.state.bind { [weak self] (state) in
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
                        self.CategoriesCollectionView.alpha = 0.0
                        self.ItemsCollectionView.alpha = 0.0
                    })
                case .loading:
                    self.loadingIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.CategoriesCollectionView.alpha = 0.0
                        self.ItemsCollectionView.alpha = 0.0
                    })
                case .populated:
                    self.loadingIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.CategoriesCollectionView.alpha = 1
                        self.ItemsCollectionView.alpha = 1
                    })
                case .none:
                    print("")
                }
            }
        }
        
        homeViewModel.alertMessage.bind { (message) in
            guard let message = message else{
                return
            }
            DispatchQueue.main.async {
                self.present(HomeView.makeAlert(message: message), animated: true, completion: nil)
            }
        }
        homeViewModel.getCategories()
    }
    
    class func makeAlert( message: String) -> UIAlertController{
        let alert = UIAlertController(title: "Alert", message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default,.cancel,.destructive:
                print("default")
            @unknown default:
                print("default")
            }}))
        return alert
    }
    
    
    @IBAction func makeCustomizition(sender: UIButton!){
        if homeViewModel.cellIsCustomizable(at: sender.tag) == true{
            performSegue(withIdentifier: "customizable", sender: sender.tag)
        }else{
            self.present(HomeView.makeAlert(message: "Is not Combo Customizable"), animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customizable"{
            if let vc = segue.destination as? CustomizableView {
                vc.ComboId = self.homeViewModel.getComboId(at: Int(sender as? Int ?? 0))
                let d = self.homeViewModel.getItemImageAndName(at: Int(sender as? Int ?? 0))
                vc.ComboImage = d.0
                vc.ComboName = d.1
            }
        }
    }
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CategoriesCollectionView{
            return homeViewModel.CategoriesCount
        }
        return homeViewModel.CategoryItemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CategoriesCollectionView {
            return .init(width: 70, height: collectionView.frame.height - leadingAndTrailing)
        }
        return .init(width: (collectionView.frame.width - spacing - 2 * leadingAndTrailing)/2, height: 310)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == CategoriesCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryID", for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            let cellvm = homeViewModel.getCategoryCellData(at: indexPath.row)
            cell.categoryCellData = cellvm
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemID", for: indexPath) as? CategoryItemCell else {
                return UICollectionViewCell()
            }
            let cellvm = homeViewModel.getCategoryItemCellData(at: indexPath.row)
            cell.ItemCellData = cellvm
            cell.customizeBtn.tag = indexPath.row
            return cell
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CategoriesCollectionView{
            homeViewModel.getCategoryItems(categoryId: homeViewModel.Categories.value?[indexPath.row].id ?? 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: leadingAndTrailing, left: leadingAndTrailing, bottom: 0, right: leadingAndTrailing)
    }
}

