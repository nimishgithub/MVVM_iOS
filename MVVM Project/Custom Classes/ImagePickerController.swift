//
//  ImagePickerController.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 22/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol AppImagePicker: ImagePickerDelegete {
    var imagePicker: ImagePickerViewController! {get set}

}
extension AppImagePicker {
    func openPicker() {
        if imagePicker == nil {
            imagePicker = ImagePickerViewController(self)
        }
        imagePicker.showImagePicker()
    }
}

protocol ImagePickerDelegete where Self: UIViewController {
    func didFinishPicking(image : UIImage)
}

class ImagePickerViewController : NSObject, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    fileprivate weak var imagePickerDelegete: ImagePickerDelegete!
    
    init(_ delegate: ImagePickerDelegete) {
        self.imagePickerDelegete = delegate
    }
    
    //MARK:- Show Image Picker Options
    func showImagePicker(){
        
        //        self.presentedView = viewController
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let takePhotoAction = UIAlertAction(title: AppTexts.takePhoto, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openCamera()
        })
        
        let choosePhotoAction = UIAlertAction(title: AppTexts.chooseFromGallery, style: .default, handler: {(alert:UIAlertAction) -> Void in
            self.openPhotolibrary()
        })
        
        //Check device has camera or not
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            optionMenu.addAction(takePhotoAction)
            optionMenu.addAction(choosePhotoAction)
        }else{
            optionMenu.addAction(choosePhotoAction)
        }
        
        let cancelAction = UIAlertAction(title: AppTexts.cancel, style: .cancel)
        optionMenu.addAction(cancelAction)
        
        imagePickerDelegete.present(optionMenu, animated: true, completion: nil)
        
    }
    
    private func openCamera(){
        self.imagePicker.sourceType = .camera
        self.imagePicker.delegate = self
        self.imagePickerDelegete.present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    private func openPhotolibrary(){
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
        self.imagePickerDelegete.present(self.imagePicker, animated: true, completion: {
            print("Did finish presenting image picker photolib.")
        })
    }
    
    
}

//MARK:- Image Picker Controller

extension ImagePickerViewController : UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        imagePicker.dismiss(animated: true) {
            self.imagePickerDelegete.didFinishPicking(image: selectedImage)
        }
    }

}
