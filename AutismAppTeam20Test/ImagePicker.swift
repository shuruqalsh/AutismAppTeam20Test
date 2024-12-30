//
//  ImagePicker.swift
//  AutismAppTeam20Test
//
//  Created by Deem Ibrahim on 30/12/2024.
//

//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    @Binding var image: UIImage?
//    var sourceType: UIImagePickerController.SourceType
//    
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(isPresented: $isPresented, image: $image)
//    }
//    
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        @Binding var isPresented: Bool
//        @Binding var image: UIImage?
//        
//        init(isPresented: Binding<Bool>, image: Binding<UIImage?>) {
//            _isPresented = isPresented
//            _image = image
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            isPresented = false
//        }
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let selectedImage = info[.originalImage] as? UIImage {
//                image = selectedImage
//            }
//            isPresented = false
//        }
//    }
//}
//
