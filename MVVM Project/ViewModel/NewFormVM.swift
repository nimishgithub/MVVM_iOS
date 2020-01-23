//
//  NewFormVM.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 22/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol NewFormDelegate: class {
    func userDidCreateNewForm(_ info: FormInfo)
}

final class NewFormVM {
    var formTitle = ""
    var formDescription = ""
    var budget = 0
    var currency: Currency = .usd
    var rate: Rate = .noPrefernce
    var paymentMethod: PaymentMethod = .noPrefernce
    var startDate: String?
    var jobTerm: JobTerm = .noPrefernce
    var attachments: [UIImage] = []
    
    private weak var delegate: NewFormDelegate?
    
    init(_ delegate: NewFormDelegate) {
        self.delegate = delegate
    }
  
    func submitForm(_ success: @escaping()->Void, error:  @escaping(NSError)->Void) {
        delegate?.userDidCreateNewForm(FormInfo(self))
        success()
    }
    
    
}
