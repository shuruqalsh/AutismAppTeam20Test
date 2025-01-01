import SwiftUI
import PhotosUI

struct EditFile: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var title: String
    @State private var emoji: String?  // الإيموجي اختياري
    @State private var imageData: Data?  // الصورة اختياريًا
    @State private var selectedItem: PhotosPickerItem? = nil
    var file: File
    var onSave: (File) -> Void

    init(file: File, onSave: @escaping (File) -> Void) {
        _title = State(initialValue: file.title)
        _emoji = State(initialValue: file.emoji)
        _imageData = State(initialValue: file.imageData)
        self.file = file
        self.onSave = onSave
    }

    var body: some View {
        VStack {
            Text("يمكنك تعديل الإيموجي أو الصورة (أحدهما يكفي).")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)

            // عرض الصورة الحالية إذا كانت موجودة
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
            }

            // زر لاختيار صورة جديدة
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("اختار صورة جديدة")
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

            // زر الحفظ
            Button("حفظ") {
                if !title.isEmpty { // تأكد من أن العنوان غير فارغ قبل الحفظ
                    // تحديث الملف
                    file.title = title
                    file.emoji = emoji
                    file.imageData = imageData
                    
                    // حفظ التغييرات
                    do {
                        try modelContext.save()
                        onSave(file)  // تمرير الملف المعدل إلى الـ parent view
                        dismiss()  // إغلاق الشيت بعد الحفظ
                    } catch {
                        print("Error saving file: \(error.localizedDescription)")
                    }
                } else {
                    // يمكنك هنا إضافة منبه للمستخدم في حال كان العنوان فارغًا
                    print("العنوان فارغ! يرجى إدخال عنوان صحيح.")
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .environment(\.layoutDirection, .rightToLeft)
    }
}
