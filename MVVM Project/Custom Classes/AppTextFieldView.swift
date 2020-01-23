//
//  CaltexTextFieldView.swift
//  CaltexTextField
//
//  Created by Nimish Sharma on 22/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AppTextFieldView: UIView {
    
    // MARK:- Types
    enum TextFieldType {
        case formTitle
        case formDescription
        case budget
        case currency
        case rate
        case paymentMethod
        case startDate
        case jobTerm
        
        var characterLimit: Int {
            switch self {
            case .formTitle: return 50
            case .formDescription: return 330
            case .budget: return 8
            default: return Int(UInt8.max)
            }
        }
     }
     
    enum State {
        case invalid(String)
        case unfilled
        case valid
        case none
        
        var associatedValue: String {
            switch self {
            case .invalid(let str):
                return str
            default:
                return ""
            }
        }
    }
    
    // MARK:- IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    @IBOutlet weak var messageLabel: UILabel!


    var userDidEnterInTextField: ((_ textFieldView: UITextField)->Void)?
    var userDidEndEditing: ((_ textFieldView: UITextField)->Void)?
    
    var setupAs: TextFieldType = .formTitle {
        didSet {
            setupAppearance()
        }
    }
    
    var state: State = .none {
        didSet {
            switch state {
            case .invalid:
                self.messageLabel.text = state.associatedValue
                self.textField.lineColor = .red
                self.messageLabel.textColor = .red
                
            case .unfilled:
                self.messageLabel.text = AppTexts.required
                self.messageLabel.textColor = .red
                self.textField.lineColor = .red
                
            case .none, .valid:
                self.messageLabel.text = nil
                self.messageLabel.textColor = AppColors.appTextGray
                self.textField.lineColor = AppColors.appTextGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AppTextFieldView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.state = .none
        self.textField.delegate = self
        self.messageLabel.numberOfLines = 0
        self.messageLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGesture)
        self.setupDefaultAppearance()
    }
    
    private func setupDefaultAppearance() {
        textField.selectedTitleColor = AppColors.appTextGray
        textField.selectedLineColor = AppColors.appDarkBlue
        textField.tintColor = AppColors.appDarkBlue
        textField.textColor = AppColors.appDarkBlue
        textField.lineColor = AppColors.appTextGray
        
        textField.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textField.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textField.lineHeight = 1
        textField.titleFormatter = { text in
            return text
        }
    }
    
    private func setupAppearance() {
        switch setupAs {
            
        case .formTitle:
            textField.placeholder = AppTexts.formTitle
            textField.keyboardType = .emailAddress
        case .formDescription:
            textField.placeholder = AppTexts.formDescription
            textField.keyboardType = .emailAddress
            
        case .budget:
            textField.placeholder = AppTexts.budget
            textField.keyboardType = .numberPad
            
        case .currency:
            textField.leftViewMode = .always
            let imageView = UIImageView(image: AppImages.usFlag)
            imageView.contentMode = .center
            imageView.frame.size = CGSize(width: 50, height: 16)
            textField.leftView = imageView
            textField.text = "  " + AppTexts.usd
            state = .valid
        case .rate:
            textField.placeholder = AppTexts.rate

        case .paymentMethod:
            textField.placeholder = AppTexts.paymentMethod

        case .startDate:
            textField.placeholder = AppTexts.startDate

        case .jobTerm:
            textField.placeholder = AppTexts.jobTerm

        }
    }
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.textField.becomeFirstResponder()
    }
    
    @IBAction private func didEnterInTextField(_ sender: SkyFloatingLabelTextField) {
        userDidEnterInTextField?(sender)
    }
    
    
    
}

extension AppTextFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .none
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location == 0 && string == " ") ||  textField.textInputMode == nil {return false}
        guard let userEnteredString = textField.text else { return false }
        let newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as NSString

        switch setupAs {
        case .formTitle, .formDescription:
            if newString.length <= setupAs.characterLimit {
                messageLabel.text = "\(setupAs.characterLimit - newString.length) characters left"
            } else {
                return false
            }
        case .budget:
            if newString.length <= setupAs.characterLimit {
            } else {
                return false
            }
        default: break
        }
        
        return textField.textInputMode != nil
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch setupAs {
        case .formTitle, .formDescription, .budget: return true
        case .currency: return false
        case .rate:
            MultiPicker.openMultiPickerIn(textField, firstComponentArray: Rate.allCases.map{$0.rawValue}, secondComponentArray: [], firstComponent: nil, secondComponent: nil, titles: nil) { (first, second) in
                textField.text = "\(first)"
            }
        case .jobTerm:
            MultiPicker.openMultiPickerIn(textField, firstComponentArray: JobTerm.allCases.map{$0.rawValue}, secondComponentArray: [], firstComponent: nil, secondComponent: nil, titles: nil) { (first, second) in
                 textField.text = "\(first)"
             }
        case .paymentMethod:
            MultiPicker.openMultiPickerIn(textField, firstComponentArray: PaymentMethod.allCases.map{$0.rawValue}, secondComponentArray: [], firstComponent: nil, secondComponent: nil, titles: nil) { (first, second) in
                 textField.text = "\(first)"
             }
        case .startDate:
            let today = Date()
            let ending = Calendar.current.date(byAdding: .month, value: 11, to: today)!
            DatePicker.openDatePickerIn(textField,
                                        outPutFormat: "EEEE dd, yyyy",
                                        mode: .date,
                                        minimumDate: today,
                                        maximumDate: ending,
                                        selectedDate: today,
                                        doneBlock: { (dateString) in
                                            // Converting String Date to Date Format
                                            print(dateString)
                                            textField.text = dateString
            })
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard reason == .committed else {
            return
        }
        
        switch setupAs {
        case .formTitle:
            if let text = textField.text, !text.isEmpty {
                if text.count < 5 {
                    state = .invalid(AppTexts.titleTooShort)
                    return
                }
            } else if textField.text?.isEmpty == true{
                state = .unfilled
                return
            }
        case .formDescription:
             if let text = textField.text, !text.isEmpty {
                 if text.count < 20 {
                     state = .invalid(AppTexts.descriptionTooShort)
                     return
                 }
             } else if textField.text?.isEmpty == true{
                 state = .unfilled
                 return
             }
        case .budget:
            if textField.text?.isEmpty == true {
                state = .unfilled
                return
            }
        default: break
            
        }
        state = .valid
        userDidEndEditing?(textField)
        
    }
    
}
