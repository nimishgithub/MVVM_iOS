//
//  FormListingVM.swift
//  
//
//  Created by Nimish Sharma on 22/01/20.
//

import Foundation


final class FormListingVM {
    
    var dataSource: [FormInfo] = []
    var dataSourceUpdateCallback: (()->Void)?
    
    // MARK: Fetch Data From Server
    func fetchDataFromServer() {}
    
}

//MARK: NewFormDelegate Methods
extension FormListingVM: NewFormDelegate {
    
    func userDidCreateNewForm(_ info: FormInfo) {
        dataSource.append(info)
        dataSourceUpdateCallback?()
    }
    
}
