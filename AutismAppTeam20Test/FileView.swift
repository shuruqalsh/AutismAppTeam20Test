//
//  FileView.swift
//  AutismAppTeam20
//
//  Created by Sumayah Alqahtani on 21/06/1446 AH.
//

//import SwiftUI
//
//struct FileView: View {
//    var file: File
//    
//    var body: some View {
//        VStack {
//            Text(file.emoji)
//                .font(.system(size: 50))  // حجم الإيموجي
//                .padding(.bottom, 5)
//                .multilineTextAlignment(.center)  // محاذاة النص للوسط
//            
//            Text(file.title)
//                .font(.system(size: 40))  // تغيير حجم خط العنوان هنا
//                .padding(.bottom, 5)
//                .multilineTextAlignment(.center)  // محاذاة النص للوسط
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
//        .padding(.bottom, 10)
//        .environment(\.layoutDirection, .rightToLeft) // تعيين اتجاه الكتابة من اليمين لليسار
//    }
//}
import SwiftUI

struct FileView: View {
    var file: File
    
    var body: some View {
        VStack {
            // عرض الصورة أولًا إذا كانت موجودة
            if let imageData = file.imageData, let uiImage = UIImage(data: imageData) {
                GeometryReader { geometry in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()  // لتغطية المساحة بالكامل مع الحفاظ على الأبعاد
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.8)  // تحديد ارتفاع الصورة بشكل نسبي
                        .clipped()  // لتقصير الصورة بحيث تملأ المربع
                }
                .frame(height: 300)  // تحديد ارتفاع المربع الذي يحتوي الصورة
            } else if let emoji = file.emoji, !emoji.isEmpty {
                // عرض الإيموجي فقط إذا كان موجودًا
                Text(emoji)
                    .font(.system(size: 200))
                    .padding(.bottom, 10)  // إضافة حشو بين الإيموجي والعنوان
            }

            // عرض عنوان الملف
            Text(file.title)
                .font(.system(size: 30))
                .padding(.bottom, 5)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .padding(.bottom, 10)
        .environment(\.layoutDirection, .rightToLeft)  // محاذاة من اليمين لليسار
    }
}


