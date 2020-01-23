//
//  FormListingVC.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 22/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

final class FormListingVC: BaseUIViewController {
    
    //    MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
   
    //    MARK: IBOutlets
    var viewModel = FormListingVM()
    
    //    MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func rightBarButtonTapped() {
        let newFormVC = NewFormVC.instantiate(fromAppStoryboard: .Main)
        newFormVC.viewModel = NewFormVM(viewModel)
        navigationController?.pushViewController(newFormVC, animated: true)
    }
    
    //    MARK: Private Methods
    private func initialSetup() {
        setupNavigationBar()
        setupTableView()
        viewModel.dataSourceUpdateCallback = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        setNavigationBar(title: AppTexts.formListing, largeTitles: false)
        addRightButtonToNavigation(image: AppImages.navigationAddBtn)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.registerCell(with: FormListingTVCell.self)
    }
    
    //    MARK: Actions
    private func moreButtonTapped(_ index: IndexPath) {
        let deleteAction = UIAlertAction(title: AppTexts.deleteForm,
                                         style: .destructive, handler: { [weak self] _ in
                                            self?.viewModel.dataSource.remove(at: index.row)
                                            self?.tableView.deleteRows(at: [index], with: .left)
        })
        deleteAction.setImage(AppImages.deleteIcon)
        deleteAction.setTextAlignment(.left)

        let cancelAction = UIAlertAction(title: AppTexts.cancel, style: .cancel, handler: nil)
        CommonFunctions.showActionSheetWithActionArray(viewController: self,
                                                       alertActionArray: [deleteAction, cancelAction],
                                                       preferredStyle: .actionSheet)
        
    }
    
    private func inviteButtonTapped(_ index: IndexPath) {
        CommonFunctions.showAlert(AppTexts.underDevelopment, AppTexts.underDevelopmentDesc, onVC: self)
    }
    
    private func inboxButtonTapped(_ index: IndexPath) {
        CommonFunctions.showAlert(AppTexts.underDevelopment, AppTexts.underDevelopmentDesc, onVC: self)
    }
}


extension FormListingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: FormListingTVCell.self, indexPath: indexPath)
        cell.populateData(viewModel.dataSource[indexPath.row])
        cell.moreBtnTappedClosure = moreButtonTapped
        cell.inviteBtnTappedClosure = inviteButtonTapped
        cell.inboxBtnTappedClosure = inboxButtonTapped
        
        return cell
    }
}

extension FormListingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
