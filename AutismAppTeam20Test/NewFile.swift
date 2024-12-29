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
import SwiftData
import PhotosUI

struct NewFile: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var files: [File]
    @State private var title: String = ""
    @State private var emoji: String? = nil  // الإيموجي اختياري
    @State private var imageData: Data? = nil  // الصورة اختياريًا
    @State private var selectedItem: PhotosPickerItem? = nil
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("يمكنك إضافة إما إيموجي أو صورة (أحدهما يكفي).")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)

            // عرض الصورة إذا كانت موجودة
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            }

            // زر لاختيار صورة
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
                    }
                }
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
    }
}

