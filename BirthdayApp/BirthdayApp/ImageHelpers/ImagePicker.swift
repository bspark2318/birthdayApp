//
//  ImagePicker.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/06/03.
//  sourced from https://designcode.io/swiftui-advanced-handbook-imagepicker

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage


    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                //Now use image to create into NSData format
                let imageData = image.pngData()!

                let strBase64 = imageData.base64EncodedString()
                
                let userID = DataManager.sharedInstance.user.userID
                let photoData = PhotoData(userID: userID, photo: strBase64)
                DataManager.sharedInstance.uploadPhoto(photoData)
//                parent.imageURL = DataManager.sharedInstance.user.profile_pic_url
                
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(selectedImage: .constant(UIImage())  )
    }
}
