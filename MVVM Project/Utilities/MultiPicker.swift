//
//  MultiPicker.swift
//  MVVM
//
//  Created by Nimish Sharma on 21/01/20.
//  Copyright © 2019 Nimish Sharma. All rights reserved.
//



import UIKit


class MultiPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal typealias PickerDone = (_ firstValue: String, _ secondValue: String) -> Void
    fileprivate var doneBlock : PickerDone!
    
    fileprivate var firstValueArray : [String]?
    fileprivate var secondValueArray = [String]()
    static private var monthsArray: [String] {
        return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    }
    
    static private var yearsArray: [String] {
        
        guard let yearString = Date().yearOfDate(), let year = Int(yearString) else { return [String]() }
        
        var arr: [String] = []
        for i in year ..< (year + 10) {
            arr.append("\(i)")
        }
        return arr
    }
    
    static var noOfComponent = 1
    
    
    class func openMultiPickerIn(_ textField: UITextField? ,
                                 firstComponentArray: [String],
                                 secondComponentArray: [String],
                                 firstComponent: String?,
                                 secondComponent: String?,
                                 titles: [String]?, doneBlock: @escaping PickerDone) {
        
        let picker = MultiPicker()
        picker.doneBlock = doneBlock
        picker.setValue(UIColor.white, forKey: "backgroundColor")
        picker.openPickerInTextField(textField,
                                     firstComponentArray: firstComponentArray,
                                     secondComponentArray: secondComponentArray,
                                     firstComponent: firstComponent,
                                     secondComponent: secondComponent)
        
        if titles != nil {
            
            let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/4 - 10,
                                              y: 0,
                                              width: 100,
                                              height: 30))
            
            label.text = titles![0].uppercased()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            
            picker.addSubview(label)
            
            if MultiPicker.noOfComponent > 1 {
                
                let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width * 3/4 - 50,
                                                  y: 0,
                                                  width: 100,
                                                  height: 30))
                
                label.text = titles![1].uppercased()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                
                picker.addSubview(label)
            } else {
                
                label.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width,
                                     height: 30)
                
                label.textAlignment = NSTextAlignment.center
            }
        }
    }
        
    fileprivate func openPickerInTextField(_ textField: UITextField?,
                                       firstComponentArray: [String],
                                       secondComponentArray: [String],
                                       firstComponent: String?, secondComponent: String?) {
        
        firstValueArray  = firstComponentArray
        secondValueArray = secondComponentArray
        
        self.delegate = self
        self.dataSource = self
        
        
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerCancelButtonTapped))
        
        cancelButton.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                         target: self,
                                         action: #selector(pickerDoneButtonTapped))
        
        doneButton.tintColor = UIColor.black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField?.inputView = self
        textField?.inputAccessoryView = toolbar
        
        let index = self.firstValueArray?.firstIndex(where: {$0 == firstComponent })
        self.selectRow(index ?? 0, inComponent: 0, animated: true)
        
        if MultiPicker.noOfComponent > 1 {
            let index1 = self.secondValueArray.firstIndex(where: {$0 == secondComponent })
            self.selectRow(index1 ?? 0, inComponent: 1, animated: true)
        }
    }
    
    @objc fileprivate func pickerCancelButtonTapped(){
        UIApplication.shared.windows.first?.endEditing(true)
    }
    
    @objc fileprivate func pickerDoneButtonTapped(){
        
        UIApplication.shared.windows.first?.endEditing(true)
        
        let index1 : Int?
        let firstValue : String?
        index1 = self.selectedRow(inComponent: 0)
        
        if let arr = firstValueArray, arr.isEmpty{
            return
        } else{
            firstValue = firstValueArray?[index1!]
        }
        
        var index2 :Int!
        var secondValue: String!
        if MultiPicker.noOfComponent > 1 {
            index2 = self.selectedRow(inComponent: 1)
            secondValue = secondValueArray[index2]
        }
        self.doneBlock(firstValue!, secondValue ?? "")
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return firstValueArray!.count
        }
        return secondValueArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return MultiPicker.noOfComponent
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
            
        case 0:
            return firstValueArray?[row]
        case 1:
            return secondValueArray[row]
        default:
            return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.numberOfLines = 2
        pickerLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        pickerLabel.textAlignment = NSTextAlignment.center
        
        switch component {
        case 0:
            pickerLabel.text =  firstValueArray?[row]
        case 1:
            pickerLabel.text =  secondValueArray[row]
        default:
            pickerLabel.text = ""
        }
        
        return pickerLabel
    }
}

class DatePicker: UIDatePicker {
    
    internal typealias PickerDone = (_ selection: String) -> Void
    fileprivate var doneBlock: PickerDone!
    fileprivate var datePickerFormat: String = ""
    
    
    fileprivate var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.datePickerFormat
        let enUSPOSIXLocale: Locale = .current
        dateFormatter.locale = enUSPOSIXLocale
        
        return dateFormatter
    }
    
    
    class func openDatePickerIn(_ textField: UITextField?,
                                outPutFormat: String,
                                mode: UIDatePicker.Mode,
                                minimumDate: Date = Date(),
                                maximumDate: Date = Date(),
                                minuteInterval: Int = 1,
                                selectedDate: Date?, doneBlock: @escaping PickerDone) {
        
        let picker = DatePicker()
        picker.doneBlock = doneBlock
        picker.datePickerFormat = outPutFormat
        picker.datePickerMode = mode
        picker.dateFormatter.dateFormat = outPutFormat
        
        if let sDate = selectedDate {
            picker.setDate(sDate, animated: false)
        }
        picker.minuteInterval = minuteInterval
        
        if mode == .time {
            let dateFormatte = DateFormatter()
            dateFormatte.dateFormat = "dd MMM yy"
            let today = dateFormatte.string(from: Date())
            let minDay = dateFormatte.string(from: minimumDate)
            let maxDay = dateFormatte.string(from: maximumDate)
            
            picker.minimumDate = today.lowercased() == minDay.lowercased() ? Date() : minimumDate
            picker.maximumDate = today.lowercased() == maxDay.lowercased() ? Date() : maximumDate
        }
        else {
            picker.minimumDate = minimumDate
            picker.maximumDate = maximumDate
        }
        
        picker.openDatePickerInTextField(textField)
    }
    
    fileprivate func openDatePickerInTextField(_ textField: UITextField?) {
        
        if let text = textField?.text, !text.isEmpty, let selDate = self.dateFormatter.date(from: text) {
            self.setDate(selDate, animated: false)
        }
        
        self.addTarget(self, action: #selector(DatePicker.datePickerChanged(_:)), for: .valueChanged)
        
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerCancelButtonTapped))
        
        cancelButton.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(pickerDoneButtonTapped))
        
        doneButton.tintColor = UIColor.black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField?.inputView = self
        textField?.inputAccessoryView = toolbar
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        //        let selected = self.dateFormatter.string(from: sender.date)
        
        //        self.doneBlock(selected)
    }
    
    @objc fileprivate func pickerCancelButtonTapped(){
        UIApplication.shared.windows.first?.endEditing(true)
    }
    
    @objc fileprivate func pickerDoneButtonTapped(){
        UIApplication.shared.windows.first?.endEditing(true)
        
        let selected = self.dateFormatter.string(from: self.date)
        
        self.doneBlock(selected)
    }
}


fileprivate extension Date {
    
    func yearOfDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func monthOfDate() -> String {
        let monthValue = Calendar.current.component(.month, from: self)
        return monthValue > 9 ? "\(monthValue)" : "0\(monthValue)"
    }
}
