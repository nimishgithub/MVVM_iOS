//
//  FormListingTVCell.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 23/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

class FormListingTVCell: UITableViewCell {
    
//    MARK: IBOutlets
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var viewsLbl: UILabel!
    
    @IBOutlet weak var rateIV: UIImageView!
    
    @IBOutlet weak var rateLbl: UILabel!
    
    @IBOutlet weak var jobTermIV: UIImageView!
    
    @IBOutlet weak var jobTermLbl: UILabel!
    
    @IBOutlet weak var buttonContainerStack: UIStackView!
    
    @IBOutlet weak var inviteBtn: UIButton!
    
    @IBOutlet weak var inboxBtn: UIButton!
    
    //    MARK: properties
    var moreBtnTappedClosure: ((_ indexPath: IndexPath)->Void)?
    var inviteBtnTappedClosure: ((_ indexPath: IndexPath)->Void)?
    var inboxBtnTappedClosure: ((_ indexPath: IndexPath)->Void)?

    
    //    MARK: Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        selectionStyle = .none
    }
    
    private func initialSetup() {
        inboxBtn.layer.borderWidth = 1.0
        inboxBtn.layer.borderColor = AppColors.appDarkBlue.cgColor
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        moreBtnTappedClosure?(indexPathInTableView ?? [0,0])
    }
    
    @IBAction private func inviteBtnTapped(_ sender: UIButton) {
        inviteBtnTappedClosure?(indexPathInTableView ?? [0,0])
    }
    
    @IBAction private func inboxBtnTapped(_ sender: UIButton) {
        inboxBtnTappedClosure?(indexPathInTableView ?? [0,0])
    }
    
    func populateData(_ model: FormInfo) {
        titleLbl.text = model.formTitle
        dateLbl.text = model.startDate
        rateLbl.text = model.rate.rawValue
        jobTermLbl.text = model.jobTerm.rawValue
    }
    
}
