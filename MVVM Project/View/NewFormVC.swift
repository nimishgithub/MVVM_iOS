//
//  NewFormVC.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 21/01/20.
//  Copyright © 2020 NewFormVC. All rights reserved.
//

import UIKit

class NewFormVC: BaseUIViewController {
    
//    MARK: IBOutlets
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var attachmentsCV: UICollectionView!
    @IBOutlet weak var formTitleTF: AppTextFieldView!
    @IBOutlet weak var formDescriptionTF: AppTextFieldView!
    @IBOutlet weak var budgetTF: AppTextFieldView!
    @IBOutlet weak var currencyTF: AppTextFieldView!
    @IBOutlet weak var rateTF: AppTextFieldView!
    @IBOutlet weak var paymentMethodTF: AppTextFieldView!
    @IBOutlet weak var startDateTF: AppTextFieldView!
    @IBOutlet weak var jobTermTF: AppTextFieldView!
    
//    MARK: ViewModel
    var viewModel: NewFormVM!

//    MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func rightBarButtonTapped() {
        guard allFieldsValid else {return}
        viewModel.submitForm({ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }) { (error) in
            CommonFunctions.showAlert(AppTexts.alert, error.localizedDescription, onVC: self)
        }
    }
    
    //    MARK: Properties
    var imagePicker: ImagePickerViewController!
    private var allFieldsValid: Bool {
        let validity = [formTitleTF, formDescriptionTF, budgetTF, currencyTF, rateTF, paymentMethodTF, startDateTF,
                                       jobTermTF].allSatisfy { textField in
                                        switch textField?.state {
                                        case .valid:
                                            return true
                                        default:
                                            return false
                                        }
        }
        return validity
    }
    
    //    MARK: Private Methods
    private func initialSetup() {
        setupNavigationBar()
        setupTextFields()
        setupCollectionView()
        containerScrollView.keyboardDismissMode = .onDrag
    }
    
    private func setupNavigationBar() {
        setNavigationBar(title: AppTexts.newForm, largeTitles: false)
        addLeftButtonToNavigation(image: AppImages.navigationBackBtn)
        addRightButtonToNavigation(title: AppTexts.send, titleColor: UIColor.white.withAlphaComponent(0.3),
                                   font: .systemFont(ofSize: 16, weight: .semibold))
    }
    
    private func setupTextFields() {
        formTitleTF.setupAs = .formTitle
        formDescriptionTF.setupAs = .formDescription
        budgetTF.setupAs = .budget
        currencyTF.setupAs = .currency
        rateTF.setupAs = .rate
        paymentMethodTF.setupAs = .paymentMethod
        startDateTF.setupAs = .startDate
        jobTermTF.setupAs = .jobTerm
        [formTitleTF, budgetTF, currencyTF, rateTF, paymentMethodTF, startDateTF, jobTermTF].forEach {
            $0?.userDidEnterInTextField = userDidEnterInTextField
            $0?.userDidEndEditing = userDidEndEditing
        }
    }
    
    private func setupCollectionView() {
        attachmentsCV.delegate = self
        attachmentsCV.dataSource = self
        attachmentsCV.registerCell(with: PickMediaCVCell.self)
        attachmentsCV.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
    private func userDidEnterInTextField(_ textField: UITextField) {
        switch textField {
        case formTitleTF.textField:
            viewModel.formTitle = textField.text ?? ""
        case formDescriptionTF.textField:
            viewModel.formDescription = textField.text ?? ""
        case budgetTF.textField:
            viewModel.budget = Int(textField.text ?? "") ?? 0
        case currencyTF.textField:
            viewModel.currency = Currency(textField.text ?? "")
        case rateTF.textField:
            viewModel.rate = Rate(textField.text ?? "")
        case paymentMethodTF.textField:
            viewModel.paymentMethod = PaymentMethod(textField.text ?? "")
        case startDateTF.textField:
            viewModel.startDate = textField.text
        case jobTermTF.textField:
            viewModel.jobTerm = JobTerm(textField.text ?? "")
        default: break
        }
    }
    
    private func userDidEndEditing(_ textField: UITextField) {
        addRightButtonToNavigation(title: AppTexts.send,
                                   titleColor: allFieldsValid ?
                                   UIColor.white : UIColor.white.withAlphaComponent(0.3),
                                   font: .systemFont(ofSize: 16, weight: .semibold))
    }
    
}

//  MARK: UICollectionView DataSources & Delegates

extension NewFormVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: PickMediaCVCell.self, indexPath: indexPath)
        switch indexPath.section {
        case 0:
            cell.setupType = .pickAttachment
        default:
            cell.setupType = .imageThumbnail
            cell.iconIV.image = viewModel.attachments[indexPath.row]
        }
        return cell
    }
}

extension NewFormVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    
}

extension NewFormVC: UICollectionViewDelegate, AppImagePicker {

    
    func didFinishPicking(image: UIImage) {
        viewModel.attachments.append(image)
        attachmentsCV.reloadSections([1])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == [0,0] {
            openPicker()
        }
    }
}
