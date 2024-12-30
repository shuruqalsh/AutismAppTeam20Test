//
//  NewFile.swift
//  AutismAppTeam20
//
//  Created by Sumayah Alqahtani on 21/06/1446 AH.
//

//import SwiftUI
//import SwiftData
//
//struct NewFile: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var files: [File]
//    @State private var title: String = ""
//    @State private var emoji: String = ""
//    @Environment(\.dismiss) var dismiss  // دالة لإغلاق الـ sheet
//
//    var body: some View {
//        VStack {
//            // حقل إدخال الإيموجي
//            TextField("أدخل الإيموجي", text: $emoji)
//                .font(.largeTitle)
//                .multilineTextAlignment(.center)
//                .padding()
//
//            // حقل إدخال اسم الملف
//            TextField("أدخل اسم الملف", text: $title)
//                .font(.largeTitle)
//                .multilineTextAlignment(.center)
//                .padding()
//
//            HStack {
//                // زر الحفظ
//                Button("حفظ") {
//                    if !title.isEmpty && !emoji.isEmpty {
//                        let newFile = File(title: title, emoji: emoji)
//                        modelContext.insert(newFile)
//                        
//                        do {
//                            try modelContext.save()
//                            files.append(newFile)
//                            title = ""
//                            emoji = ""
//                            dismiss()  // إغلاق الـ sheet بعد الحفظ
//                        } catch {
//                            print("Error saving file: \(error.localizedDescription)")
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                // زر الإلغاء
//                Button("إلغاء") {
//                    // إعادة تعيين الحقول
//                    title = ""
//                    emoji = ""
//                    dismiss()  // إغلاق الـ sheet عند الإلغاء
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding(.top, 20)
//
//            Spacer()
//        }
//        .padding()
//        .environment(\.layoutDirection, .rightToLeft) // تعيين اتجاه الكتابة من اليمين لليسار
//    }
//}
import SwiftUI
import PhotosUI
import UIKit

struct NewFile: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var files: [File]
    @State private var title: String = ""
    @State private var emoji: String? = nil  // الإيموجي اختياري
    @State private var imageData: Data? = nil  // الصورة اختياريًا
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isCameraPresented: Bool = false
    @State private var uiImage: UIImage? = nil  // لتخزين الصورة التي تم التقاطها أو اختيارها
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("يمكنك إضافة إما إيموجي أو صورة (أحدهما يكفي).")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)

            // عرض الصورة إذا كانت موجودة
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            } else if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            }

            // زر لاختيار صورة من مكتبة الصور
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("اختار صورة")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        imageData = data
                        uiImage = UIImage(data: data) // تحويل البيانات إلى صورة
                    }
                }
            }

            // زر لفتح الكاميرا (فتح الكاميرا مباشرة بدون الذهاب إلى مكتبة الصور)
            Button(action: {
                isCameraPresented = true
            }) {
                Text("التقط صورة")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }

            // حقل إدخال الإيموجي (اختياري)
            TextField("أدخل الإيموجي (اختياري)", text: Binding(
                get: { emoji ?? "" },
                set: { emoji = $0.isEmpty ? nil : $0 }
            ))
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()

            // حقل إدخال اسم الملف
            TextField("أدخل اسم الملف", text: $title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()

            HStack {
                // زر الحفظ
                Button("حفظ") {
                    if !title.isEmpty {
                        let newFile = File(title: title, emoji: emoji, imageData: imageData)
                        modelContext.insert(newFile)
                        
                        do {
                            try modelContext.save()
                            files.append(newFile)
                            title = ""
                            emoji = nil
                            imageData = nil
                            dismiss()  // إغلاق الـ sheet بعد الحفظ
                        } catch {
                            print("Error saving file: \(error.localizedDescription)")
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                // زر الإلغاء
                Button("إلغاء") {
                    // إعادة تعيين الحقول
                    title = ""
                    emoji = nil
                    imageData = nil
                    dismiss()  // إغلاق الـ sheet عند الإلغاء
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .environment(\.layoutDirection, .rightToLeft) // تعيين اتجاه الكتابة من اليمين لليسار
        .sheet(isPresented: $isCameraPresented) {
            ImagePicker(isPresented: $isCameraPresented, image: $uiImage, sourceType: .camera) // التأكد من الكاميرا
        }
    }
}

// UIViewControllerRepresentable لدمج UIImagePickerController مع SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented, image: $image)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var image: UIImage?
        
        init(isPresented: Binding<Bool>, image: Binding<UIImage?>) {
            _isPresented = isPresented
            _image = image
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                image = selectedImage
            }
            isPresented = false
        }
    }
}
