//
//  AppGlobals.swift
//  
//
//  Created by Nimish Sharma on 22/01/20.
//

import Foundation

enum Rate: String, CaseIterable {
    case noPrefernce = "No Preference"
    case fixedBudget = "Fixed Budget"
    case hourlyRate = "Hourly Rate"
    
    init(_ rawVal: String) {
        self = Rate(rawValue: rawVal) ?? .noPrefernce
    }
}

enum JobTerm: String, CaseIterable {
    case noPrefernce = "No Preference"
    case recurringJob = "Recurring Job"
    case sameDayJob = "Same Day Job"
    case multiDaysJob = "Multi Days Job"
    
    init(_ rawVal: String) {
        self = JobTerm(rawValue: rawVal) ?? .noPrefernce
    }
}

enum PaymentMethod: String, CaseIterable {
    case noPrefernce = "No Preference"
    case ePayment = "E-Payment"
    case cash = "Cash"
    
    init(_ rawVal: String) {
        self = PaymentMethod(rawValue: rawVal) ?? .noPrefernce
    }
}

enum Currency: String {
    case usd = "USD"
    case rupees = "Rupees"
    init(_ rawVal: String) {
        self = Currency(rawValue: rawVal) ?? .usd
    }
}
