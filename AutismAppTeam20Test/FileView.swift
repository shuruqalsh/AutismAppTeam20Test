
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
                        .frame(width: geometry.size.width, height: geometry.size.height * 1.26)  // تحديد ارتفاع الصورة بشكل نسبي
                        .clipped()  // لتقصير الصورة بحيث تملأ المربع
                }
                .frame(height: 200)  // تحديد ارتفاع المربع الذي يحتوي الصورة
            } else if let emoji = file.emoji, !emoji.isEmpty {
                // عرض الإيموجي فقط إذا كان موجودًا
                Text(emoji)
                    .font(.system(size: 200))
                    .padding(.bottom, 10)  // إضافة حشو بين الإيموجي والعنوان
            }
            Spacer()
            // عرض عنوان الملف
            Text(file.title)
                .font(.system(size: 30))
//                .padding(.bottom, 10)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .padding(.bottom, 10)
        .environment(\.layoutDirection, .rightToLeft)  // محاذاة من اليمين لليسار
    }
}
