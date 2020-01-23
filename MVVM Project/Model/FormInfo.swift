//
//  FormInfo.swift
//  
//
//  Created by Nimish Sharma on 22/01/20.
//

import Foundation

struct FormInfo {
    let formTitle: String
    let formDescription: String
    let budget: Int
    let rate: Rate
    let paymentMethod: PaymentMethod
    let jobTerm: JobTerm
    let startDate: String
//    let attachments: [UIImage]

    init(_ newFormVM: NewFormVM) {
        formTitle = newFormVM.formTitle
        formDescription = newFormVM.formDescription
        budget = newFormVM.budget
        rate = newFormVM.rate
        paymentMethod = newFormVM.paymentMethod
        jobTerm = newFormVM.jobTerm
        startDate = newFormVM.startDate ?? ""
    }
}
