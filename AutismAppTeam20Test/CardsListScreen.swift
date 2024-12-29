//
//  CardsListScreen.swift
//  AutismAppTeam20
//
//  Created by Sumayah Alqahtani on 21/06/1446 AH.
//

//import SwiftUI
//import SwiftData
//
//struct CardsListScreen: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var showingNewCardSheet = false
//    @State private var showingEditCardSheet = false  // حالة لعرض نافذة تعديل البطاقة
//    @State private var cardToEdit: Card?  // العنصر الذي سيتم تعديله
//    @State private var showingDeleteConfirmation = false  // حالة لعرض التنبيه
//    @State private var cardToDelete: Card?  // العنصر الذي سيتم حذفه
//
//    let columns: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(file.cards) { card in
//                        HStack {
//                            CardView(card: card)
//                            
//                            // زر تعديل
//                            Button(action: {
//                                cardToEdit = card  // تعيين البطاقة التي سيتم تعديلها
//                                showingEditCardSheet.toggle()  // إظهار نافذة التعديل
//                            }) {
//                                Image(systemName: "pencil")
//                                    .foregroundColor(.blue)
//                                    .padding(8)
//                            }
//                            
//                            // زر حذف
//                            Button(action: {
//                                cardToDelete = card  // تعيين البطاقة التي سيتم حذفها
//                                showingDeleteConfirmation = true  // إظهار التنبيه للحذف
//                            }) {
//                                Image(systemName: "trash")
//                                    .foregroundColor(.red)
//                                    .padding(8)
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//            
//            Button(action: {
//                showingNewCardSheet.toggle()
//            }) {
//                Text("إضافة بطاقة جديدة")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//            .sheet(isPresented: $showingNewCardSheet) {
//                NewCard(file: $file)
//            }
//        }
//        .navigationTitle(file.title)
//        .onAppear {
//            loadCards()
//        }
//        // نافذة تعديل البطاقة
//        .sheet(isPresented: $showingEditCardSheet) {
//            if let cardToEdit = cardToEdit {
//                EditCard(card: cardToEdit) { updatedCard in
//                    if let index = file.cards.firstIndex(where: { $0.id == updatedCard.id }) {
//                        file.cards[index] = updatedCard  // تحديث البطاقة في القائمة
//                    }
//                }
//            }
//        }
//        // التنبيه الذي يطلب تأكيد الحذف
//        .alert(isPresented: $showingDeleteConfirmation) {
//            Alert(
//                title: Text("هل أنت متأكد؟"),
//                message: Text("هل ترغب في حذف هذه البطاقة؟ هذه العملية لا يمكن التراجع عنها."),
//                primaryButton: .destructive(Text("حذف")) {
//                    if let cardToDelete = cardToDelete {
//                        deleteCard(cardToDelete)
//                    }
//                },
//                secondaryButton: .cancel(Text("إلغاء"))
//            )
//        }
//        .environment(\.layoutDirection, .rightToLeft) // محاذاة الواجهة من اليمين لليسار
//    }
//    
//    private func loadCards() {
//        // يمكنك هنا إضافة طريقة لتحميل البطاقات إذا كان هناك حاجة
//    }
//
//    // دالة لحذف البطاقة
//    private func deleteCard(_ card: Card) {
//        if let index = file.cards.firstIndex(where: { $0.id == card.id }) {
//            file.cards.remove(at: index)
//        }
//        
//        modelContext.delete(card)
//        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error deleting card: \(error.localizedDescription)")
//        }
//    }
//}
//import SwiftUI
//import SwiftData
//
//struct CardsListScreen: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var showingNewCardSheet = false
//    @State private var showingEditCardSheet = false  // حالة لعرض نافذة تعديل البطاقة
//    @State private var cardToEdit: Card?  // العنصر الذي سيتم تعديله
//    @State private var showingDeleteConfirmation = false  // حالة لعرض التنبيه
//    @State private var cardToDelete: Card?  // العنصر الذي سيتم حذفه
//    @State private var showButtonsForCard: Card?  // بطاقة التي ستظهر لها الأزرار
//
//    let columns: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(file.cards) { card in
//                        VStack {
//                            CardView(card: card)  // عرض البطاقة
//                                .padding()
//                                .onTapGesture(count: 2) {  // استماع للدبل كليك
//                                    withAnimation {
//                                        // عند الدبل كليك، نعرض أو نخفي الأزرار
//                                        if showButtonsForCard == card {
//                                            showButtonsForCard = nil  // إخفاء الأزرار إذا كانت ظاهرة
//                                        } else {
//                                            showButtonsForCard = card  // عرض الأزرار
//                                        }
//                                    }
//                                }
//
//                            // الأزرار أسفل البطاقة (تظهر فقط إذا كانت البطاقة هي التي تم الدبل كليك عليها)
//                            if showButtonsForCard == card {
//                                HStack(spacing: 16) {
//                                    // زر تعديل
//                                    Button(action: {
//                                        cardToEdit = card  // تعيين البطاقة التي سيتم تعديلها
//                                        showingEditCardSheet.toggle()  // إظهار نافذة التعديل
//                                    }) {
//                                        Image(systemName: "pencil")
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.blue)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//
//                                    // زر حذف
//                                    Button(action: {
//                                        cardToDelete = card  // تعيين البطاقة التي سيتم حذفها
//                                        showingDeleteConfirmation = true  // إظهار التنبيه للحذف
//                                    }) {
//                                        Image(systemName: "trash")
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.red)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//                                }
//                                .padding(.top, 8)  // إضافة بعض المسافة بين البطاقة والأزرار
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//            
//            Button(action: {
//                showingNewCardSheet.toggle()
//            }) {
//                Text("إضافة بطاقة جديدة")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//            .sheet(isPresented: $showingNewCardSheet) {
//                NewCard(file: $file)
//            }
//        }
//        .navigationTitle(file.title)
//        .onAppear {
//            loadCards()
//        }
//        // نافذة تعديل البطاقة
//        .sheet(isPresented: $showingEditCardSheet) {
//            if let cardToEdit = cardToEdit {
//                EditCard(card: cardToEdit) { updatedCard in
//                    if let index = file.cards.firstIndex(where: { $0.id == updatedCard.id }) {
//                        file.cards[index] = updatedCard  // تحديث البطاقة في القائمة
//                    }
//                }
//            }
//        }
//        // التنبيه الذي يطلب تأكيد الحذف
//        .alert(isPresented: $showingDeleteConfirmation) {
//            Alert(
//                title: Text("هل أنت متأكد؟"),
//                message: Text("هل ترغب في حذف هذه البطاقة؟ هذه العملية لا يمكن التراجع عنها."),
//                primaryButton: .destructive(Text("حذف")) {
//                    if let cardToDelete = cardToDelete {
//                        deleteCard(cardToDelete)
//                    }
//                },
//                secondaryButton: .cancel(Text("إلغاء"))
//            )
//        }
//        .environment(\.layoutDirection, .rightToLeft) // محاذاة الواجهة من اليمين لليسار
//    }
//    
//    private func loadCards() {
//        // يمكنك هنا إضافة طريقة لتحميل البطاقات إذا كان هناك حاجة
//    }
//
//    // دالة لحذف البطاقة
//    private func deleteCard(_ card: Card) {
//        if let index = file.cards.firstIndex(where: { $0.id == card.id }) {
//            file.cards.remove(at: index)
//        }
//        
//        modelContext.delete(card)
//        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error deleting card: \(error.localizedDescription)")
//        }
//    }
//}
//import SwiftUI
//import SwiftData
//
//struct CardsListScreen: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var showingNewCardSheet = false
//    @State private var showingEditCardSheet = false  // حالة لعرض نافذة تعديل البطاقة
//    @State private var cardToEdit: Card?  // العنصر الذي سيتم تعديله
//    @State private var showingDeleteConfirmation = false  // حالة لعرض التنبيه
//    @State private var cardToDelete: Card?  // العنصر الذي سيتم حذفه
//    @State private var showButtonsForCard: Card?  // بطاقة التي ستظهر لها الأزرار
//    @State private var showPasswordPrompt = false  // عرض نافذة إدخال الرقم السري
//    @State private var password = ""  // الرقم السري المدخل
//    @State private var passwordError = false  // حالة لتحديد إذا كان الرقم السري خاطئًا
//
//    let correctPassword = "1234"  // الرقم السري الصحيح (يمكن تغييره إلى أي شيء آخر)
//
//    let columns: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(file.cards) { card in
//                        VStack {
//                            CardView(card: card)  // عرض البطاقة
//                                .padding()
//                                .onTapGesture(count: 2) {  // استماع للدبل كليك
//                                    withAnimation {
//                                        // عند الدبل كليك، نعرض نافذة الرقم السري
//                                        if showButtonsForCard == card {
//                                            showButtonsForCard = nil  // إخفاء الأزرار إذا كانت ظاهرة
//                                        } else {
//                                            showPasswordPrompt = true  // إظهار نافذة إدخال الرقم السري
//                                            cardToEdit = card  // تعيين البطاقة التي سيتم التعامل معها
//                                        }
//                                    }
//                                }
//
//                            // الأزرار أسفل البطاقة (تظهر فقط إذا كانت البطاقة هي التي تم الدبل كليك عليها)
//                            if showButtonsForCard == card {
//                                HStack(spacing: 16) {
//                                    // زر تعديل
//                                    Button(action: {
//                                        cardToEdit = card  // تعيين البطاقة التي سيتم تعديلها
//                                        showingEditCardSheet.toggle()  // إظهار نافذة التعديل
//                                    }) {
//                                        Image(systemName: "pencil")
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.blue)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//
//                                    // زر حذف
//                                    Button(action: {
//                                        cardToDelete = card  // تعيين البطاقة التي سيتم حذفها
//                                        showingDeleteConfirmation = true  // إظهار التنبيه للحذف
//                                    }) {
//                                        Image(systemName: "trash")
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.red)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//                                }
//                                .padding(.top, 8)  // إضافة بعض المسافة بين البطاقة والأزرار
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//            
//            Button(action: {
//                showingNewCardSheet.toggle()
//            }) {
//                Text("إضافة بطاقة جديدة")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//            .sheet(isPresented: $showingNewCardSheet) {
//                NewCard(file: $file)
//            }
//        }
//        .navigationTitle(file.title)
//        .onAppear {
//            loadCards()
//        }
//        // نافذة تعديل البطاقة
//        .sheet(isPresented: $showingEditCardSheet) {
//            if let cardToEdit = cardToEdit {
//                EditCard(card: cardToEdit) { updatedCard in
//                    if let index = file.cards.firstIndex(where: { $0.id == updatedCard.id }) {
//                        file.cards[index] = updatedCard  // تحديث البطاقة في القائمة
//                    }
//                }
//            }
//        }
//        // التنبيه الذي يطلب تأكيد الحذف
//        .alert(isPresented: $showingDeleteConfirmation) {
//            Alert(
//                title: Text("هل أنت متأكد؟"),
//                message: Text("هل ترغب في حذف هذه البطاقة؟ هذه العملية لا يمكن التراجع عنها."),
//                primaryButton: .destructive(Text("حذف")) {
//                    if let cardToDelete = cardToDelete {
//                        deleteCard(cardToDelete)
//                    }
//                },
//                secondaryButton: .cancel(Text("إلغاء"))
//            )
//        }
//        // نافذة إدخال الرقم السري
//        .sheet(isPresented: $showPasswordPrompt) {
//            VStack(spacing: 20) {
//                Text("أدخل الرقم السري")
//                    .font(.headline)
//                
//                SecureField("الرقم السري", text: $password)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//                
//                if passwordError {
//                    Text("الرقم السري غير صحيح.")
//                        .foregroundColor(.red)
//                }
//
//                Button(action: {
//                    // تحقق من الرقم السري
//                    if password == correctPassword {
//                        showButtonsForCard = cardToEdit  // إذا كان الرقم السري صحيحًا، نعرض الأزرار
//                        showPasswordPrompt = false  // إغلاق نافذة الرقم السري
//                    } else {
//                        passwordError = true  // الرقم السري خاطئ
//                    }
//                }) {
//                    Text("تأكيد")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//        }
//        .environment(\.layoutDirection, .rightToLeft) // محاذاة الواجهة من اليمين لليسار
//    }
//    
//    private func loadCards() {
//        // يمكنك هنا إضافة طريقة لتحميل البطاقات إذا كان هناك حاجة
//    }
//
//    // دالة لحذف البطاقة
//    private func deleteCard(_ card: Card) {
//        if let index = file.cards.firstIndex(where: { $0.id == card.id }) {
//            file.cards.remove(at: index)
//        }
//        
//        modelContext.delete(card)
//        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error deleting card: \(error.localizedDescription)")
//        }
//    }
//}
//import SwiftUI
//import SwiftData
//
//struct CardsListScreen: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var showingNewCardSheet = false
//    @State private var showingEditCardSheet = false  // حالة لعرض نافذة تعديل البطاقة
//    @State private var cardToEdit: Card?  // العنصر الذي سيتم تعديله
//    @State private var showingDeleteConfirmation = false  // حالة لعرض التنبيه
//    @State private var cardToDelete: Card?  // العنصر الذي سيتم حذفه
//    @State private var showButtonsForCard: Card?  // بطاقة التي ستظهر لها الأزرار
//    @State private var showPasswordPrompt = false  // عرض نافذة إدخال الرقم السري
//    @State private var password = ""  // الرقم السري المدخل
//    @State private var passwordError = false  // حالة لتحديد إذا كان الرقم السري خاطئًا
//    @State private var showPassword = false  // التحكم في إظهار/إخفاء كلمة المرور
//
//    let correctPassword = "1234"  // الرقم السري الصحيح (يمكن تغييره إلى أي شيء آخر)
//
//    let columns: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(file.cards) { card in
//                        VStack {
//                            CardView(card: card)  // عرض البطاقة
//                                .padding()
//                                .onTapGesture(count: 2) {  // استماع للدبل كليك
//                                    withAnimation {
//                                        // عند الدبل كليك، نعرض نافذة الرقم السري
//                                        if showButtonsForCard == card {
//                                            showButtonsForCard = nil  // إخفاء الأزرار إذا كانت ظاهرة
//                                        } else {
//                                            showPasswordPrompt = true  // إظهار نافذة إدخال الرقم السري
//                                            cardToEdit = card  // تعيين البطاقة التي سيتم التعامل معها
//                                        }
//                                    }
//                                }
//
//                            // الأزرار أسفل البطاقة (تظهر فقط إذا كانت البطاقة هي التي تم الدبل كليك عليها)
//                            if showButtonsForCard == card {
//                                HStack(spacing: 16) {
//                                    // زر تعديل
//                                    Button(action: {
//                                        cardToEdit = card  // تعيين البطاقة التي سيتم تعديلها
//                                        showingEditCardSheet.toggle()  // إظهار نافذة التعديل
//                                    }) {
//                                        Image(systemName: "pencil")
//                                            .font(.system(size: 22, weight: .bold))  // تكبير الرمز وجعله بولد
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.blue)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//
//                                    // زر حذف
//                                    Button(action: {
//                                        cardToDelete = card  // تعيين البطاقة التي سيتم حذفها
//                                        showingDeleteConfirmation = true  // إظهار التنبيه للحذف
//                                    }) {
//                                        Image(systemName: "trash")
//                                            .font(.system(size: 22, weight: .bold))  // تكبير الرمز وجعله بولد
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.red)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//                                }
//                                .padding(.top, 8)  // إضافة بعض المسافة بين البطاقة والأزرار
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//            
//            Button(action: {
//                showingNewCardSheet.toggle()
//            }) {
//                Text("إضافة بطاقة جديدة")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//            .sheet(isPresented: $showingNewCardSheet) {
//                NewCard(file: $file)
//            }
//        }
//        .navigationTitle(file.title)
//        .onAppear {
//            loadCards()
//        }
//        // نافذة تعديل البطاقة
//        .sheet(isPresented: $showingEditCardSheet) {
//            if let cardToEdit = cardToEdit {
//                EditCard(card: cardToEdit) { updatedCard in
//                    if let index = file.cards.firstIndex(where: { $0.id == updatedCard.id }) {
//                        file.cards[index] = updatedCard  // تحديث البطاقة في القائمة
//                    }
//                }
//            }
//        }
//        // التنبيه الذي يطلب تأكيد الحذف
//        .alert(isPresented: $showingDeleteConfirmation) {
//            Alert(
//                title: Text("هل أنت متأكد؟"),
//                message: Text("هل ترغب في حذف هذه البطاقة؟ هذه العملية لا يمكن التراجع عنها."),
//                primaryButton: .destructive(Text("حذف")) {
//                    if let cardToDelete = cardToDelete {
//                        deleteCard(cardToDelete)
//                    }
//                },
//                secondaryButton: .cancel(Text("إلغاء"))
//            )
//        }
//        // نافذة إدخال الرقم السري
//        .sheet(isPresented: $showPasswordPrompt) {
//            VStack(spacing: 20) {
//                Text("أدخل الرقم السري")
//                    .font(.headline)
//                
//                // حقل النص الذي يمكن رؤية الباسورد فيه
//                HStack {
//                    if showPassword {
//                        TextField("الرقم السري", text: $password)
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .multilineTextAlignment(.center)  // نص في المنتصف
//                            .padding(.horizontal)
//                    } else {
//                        SecureField("الرقم السري", text: $password)
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .multilineTextAlignment(.center)  // نص في المنتصف
//                            .padding(.horizontal)
//                    }
//                }
//                
//                if passwordError {
//                    Text("الرقم السري غير صحيح.")
//                        .foregroundColor(.red)
//                }
//
//                Button(action: {
//                    // تحقق من الرقم السري
//                    if password == correctPassword {
//                        showButtonsForCard = cardToEdit  // إذا كان الرقم السري صحيحًا، نعرض الأزرار
//                        showPasswordPrompt = false  // إغلاق نافذة الرقم السري
//                    } else {
//                        passwordError = true  // الرقم السري خاطئ
//                    }
//                }) {
//                    Text("تأكيد")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//
//                // زر للتبديل بين إظهار وإخفاء كلمة المرور
//                Button(action: {
//                    showPassword.toggle()
//                }) {
//                    Text(showPassword ? "إخفاء الرقم السري" : "إظهار الرقم السري")
//                        .font(.body)
//                        .foregroundColor(.blue)
//                }
//                .padding(.top)
//            }
//            .padding()
//        }
//        .environment(\.layoutDirection, .rightToLeft) // محاذاة الواجهة من اليمين لليسار
//    }
//    
//    private func loadCards() {
//        // يمكنك هنا إضافة طريقة لتحميل البطاقات إذا كان هناك حاجة
//    }
//
//    // دالة لحذف البطاقة
//    private func deleteCard(_ card: Card) {
//        if let index = file.cards.firstIndex(where: { $0.id == card.id }) {
//            file.cards.remove(at: index)
//        }
//        
//        modelContext.delete(card)
//        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error deleting card: \(error.localizedDescription)")
//        }
//    }
//}

//import SwiftUI
//import SwiftData
//
//struct CardsListScreen: View {
//    @Environment(\.modelContext) private var modelContext
//    @Binding var file: File
//    @State private var showingNewCardSheet = false
//    @State private var showingEditCardSheet = false  // حالة لعرض نافذة تعديل البطاقة
//    @State private var cardToEdit: Card?  // العنصر الذي سيتم تعديله
//    @State private var showingDeleteConfirmation = false  // حالة لعرض التنبيه
//    @State private var cardToDelete: Card?  // العنصر الذي سيتم حذفه
//    @State private var showButtonsForCard: Card?  // بطاقة التي ستظهر لها الأزرار
//    @State private var showPasswordPrompt = false  // عرض نافذة إدخال الرقم السري
//    @State private var password = ""  // الرقم السري المدخل
//    @State private var passwordError = false  // حالة لتحديد إذا كان الرقم السري خاطئًا
//    @State private var showPassword = false  // التحكم في إظهار/إخفاء كلمة المرور
//
//    let correctPassword = "1234"  // الرقم السري الصحيح (يمكن تغييره إلى أي شيء آخر)
//
//    let columns: [GridItem] = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(file.cards) { card in
//                        VStack {
//                            CardView(card: card)  // عرض البطاقة
//                                .padding()
//                                .onTapGesture(count: 2) {  // استماع للدبل كليك
//                                    withAnimation {
//                                        // عند الدبل كليك، نعرض نافذة الرقم السري
//                                        if showButtonsForCard == card {
//                                            showButtonsForCard = nil  // إخفاء الأزرار إذا كانت ظاهرة
//                                        } else {
//                                            showPasswordPrompt = true  // إظهار نافذة إدخال الرقم السري
//                                            password = ""  // إعادة تعيين الرقم السري إلى فارغ
//                                            cardToEdit = card  // تعيين البطاقة التي سيتم التعامل معها
//                                        }
//                                    }
//                                }
//
//                            // الأزرار أسفل البطاقة (تظهر فقط إذا كانت البطاقة هي التي تم الدبل كليك عليها)
//                            if showButtonsForCard == card {
//                                HStack(spacing: 16) {
//                                    // زر تعديل
//                                    Button(action: {
//                                        cardToEdit = card  // تعيين البطاقة التي سيتم تعديلها
//                                        showingEditCardSheet.toggle()  // إظهار نافذة التعديل
//                                    }) {
//                                        Image(systemName: "pencil")
//                                            .font(.system(size: 22, weight: .bold))  // تكبير الرمز وجعله بولد
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.blue)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//
//                                    // زر حذف
//                                    Button(action: {
//                                        cardToDelete = card  // تعيين البطاقة التي سيتم حذفها
//                                        showingDeleteConfirmation = true  // إظهار التنبيه للحذف
//                                    }) {
//                                        Image(systemName: "trash")
//                                            .font(.system(size: 22, weight: .bold))  // تكبير الرمز وجعله بولد
//                                            .foregroundColor(.white)
//                                            .padding(12)  // إضافة الحشو داخل الدائرة
//                                            .background(Color.red)
//                                            .clipShape(Circle())  // جعل الشكل دائريًا
//                                    }
//                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
//                                }
//                                .padding(.top, 8)  // إضافة بعض المسافة بين البطاقة والأزرار
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//            
//            Button(action: {
//                showingNewCardSheet.toggle()
//            }) {
//                Text("إضافة بطاقة جديدة")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//            .sheet(isPresented: $showingNewCardSheet) {
//                NewCard(file: $file)
//            }
//        }
//        .navigationTitle(file.title)
//        .onAppear {
//            loadCards()
//        }
//        // نافذة تعديل البطاقة
//        .sheet(isPresented: $showingEditCardSheet) {
//            if let cardToEdit = cardToEdit {
//                EditCard(card: cardToEdit) { updatedCard in
//                    if let index = file.cards.firstIndex(where: { $0.id == updatedCard.id }) {
//                        file.cards[index] = updatedCard  // تحديث البطاقة في القائمة
//                    }
//                }
//            }
//        }
//        // التنبيه الذي يطلب تأكيد الحذف
//        .alert(isPresented: $showingDeleteConfirmation) {
//            Alert(
//                title: Text("هل أنت متأكد؟"),
//                message: Text("هل ترغب في حذف هذه البطاقة؟ هذه العملية لا يمكن التراجع عنها."),
//                primaryButton: .destructive(Text("حذف")) {
//                    if let cardToDelete = cardToDelete {
//                        deleteCard(cardToDelete)
//                    }
//                },
//                secondaryButton: .cancel(Text("إلغاء"))
//            )
//        }
//        // نافذة إدخال الرقم السري
//        .sheet(isPresented: $showPasswordPrompt) {
//            VStack(spacing: 20) {
//                Text("أدخل الرقم السري")
//                    .font(.headline)
//                
//                // حقل النص الذي يمكن رؤية الباسورد فيه
//                HStack {
//                    if showPassword {
//                        TextField("الرقم السري", text: $password)
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .multilineTextAlignment(.center)  // نص في المنتصف
//                            .padding(.horizontal)
//                    } else {
//                        SecureField("الرقم السري", text: $password)
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .multilineTextAlignment(.center)  // نص في المنتصف
//                            .padding(.horizontal)
//                    }
//                }
//                
//                if passwordError {
//                    Text("الرقم السري غير صحيح.")
//                        .foregroundColor(.red)
//                }
//
//                Button(action: {
//                    // تحقق من الرقم السري
//                    if password == correctPassword {
//                        showButtonsForCard = cardToEdit  // إذا كان الرقم السري صحيحًا، نعرض الأزرار
//                        showPasswordPrompt = false  // إغلاق نافذة الرقم السري
//                    } else {
//                        passwordError = true  // الرقم السري خاطئ
//                    }
//                }) {
//                    Text("تأكيد")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//
//                // زر للتبديل بين إظهار وإخفاء كلمة المرور
//                Button(action: {
//                    showPassword.toggle()
//                }) {
//                    Text(showPassword ? "إخفاء الرقم السري" : "إظهار الرقم السري")
//                        .font(.body)
//                        .foregroundColor(.blue)
//                }
//                .padding(.top)
//            }
//            .padding()
//        }
//        .environment(\.layoutDirection, .rightToLeft) // محاذاة الواجهة من اليمين لليسار
//    }
//    
//    private func loadCards() {
//        // يمكنك هنا إضافة طريقة لتحميل البطاقات إذا كان هناك حاجة
//    }
//
//    // دالة لحذف البطاقة
//    private func deleteCard(_ card: Card) {
//        if let index = file.cards.firstIndex(where: { $0.id == card.id }) {
//            file.cards.remove(at: index)
//        }
//        
//        modelContext.delete(card)
//        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error deleting card: \(error.localizedDescription)")
//        }
//    }
//}
import SwiftUI
import SwiftData

struct CardsListScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var file: File
    @State private var showingNewCardSheet = false
    @State private var showingEditCardSheet = false  // حالة لعرض نافذة تعديل البطاقة
    @State private var cardToEdit: Card?  // العنصر الذي سيتم تعديله
    @State private var showingDeleteConfirmation = false  // حالة لعرض التنبيه
    @State private var cardToDelete: Card?  // العنصر الذي سيتم حذفه
    @State private var showButtonsForCard: Card?  // بطاقة التي ستظهر لها الأزرار
    @State private var showPasswordPrompt = false  // عرض نافذة إدخال الرقم السري
    @State private var password = ""  // الرقم السري المدخل
    @State private var passwordError = false  // حالة لتحديد إذا كان الرقم السري خاطئًا
    @State private var showPassword = false  // التحكم في إظهار/إخفاء كلمة المرور

    let correctPassword = "1234"  // الرقم السري الصحيح (يمكن تغييره إلى أي شيء آخر)

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(file.cards) { card in
                        VStack {
                            CardView(card: card)  // عرض البطاقة
                                .padding()
                                .onLongPressGesture(minimumDuration: 0.5) {  // استماع للضغط المطول
                                    withAnimation {
                                        // عند الضغط المطول، نعرض نافذة الرقم السري
                                        if showButtonsForCard == card {
                                            showButtonsForCard = nil  // إخفاء الأزرار إذا كانت ظاهرة
                                        } else {
                                            showPasswordPrompt = true  // إظهار نافذة إدخال الرقم السري
                                            password = ""  // إعادة تعيين الرقم السري إلى فارغ
                                            cardToEdit = card  // تعيين البطاقة التي سيتم التعامل معها
                                        }
                                    }
                                }

                            // الأزرار أسفل البطاقة (تظهر فقط إذا كانت البطاقة هي التي تم الضغط المطول عليها)
                            if showButtonsForCard == card {
                                HStack(spacing: 16) {
                                    // زر تعديل
                                    Button(action: {
                                        cardToEdit = card  // تعيين البطاقة التي سيتم تعديلها
                                        showingEditCardSheet.toggle()  // إظهار نافذة التعديل
                                    }) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 22, weight: .bold))  // تكبير الرمز وجعله بولد
                                            .foregroundColor(.white)
                                            .padding(12)  // إضافة الحشو داخل الدائرة
                                            .background(Color.blue)
                                            .clipShape(Circle())  // جعل الشكل دائريًا
                                    }
                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة

                                    // زر حذف
                                    Button(action: {
                                        cardToDelete = card  // تعيين البطاقة التي سيتم حذفها
                                        showingDeleteConfirmation = true  // إظهار التنبيه للحذف
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 22, weight: .bold))  // تكبير الرمز وجعله بولد
                                            .foregroundColor(.white)
                                            .padding(12)  // إضافة الحشو داخل الدائرة
                                            .background(Color.red)
                                            .clipShape(Circle())  // جعل الشكل دائريًا
                                    }
                                    .frame(width: 44, height: 44)  // تحديد حجم الدائرة
                                }
                                .padding(.top, 8)  // إضافة بعض المسافة بين البطاقة والأزرار
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: {
                showingNewCardSheet.toggle()
            }) {
                Text("إضافة بطاقة جديدة")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showingNewCardSheet) {
                NewCard(file: $file)
            }
        }
        .navigationTitle(file.title)
        .onAppear {
            loadCards()
        }
        // نافذة تعديل البطاقة
        .sheet(isPresented: $showingEditCardSheet) {
            if let cardToEdit = cardToEdit {
                EditCard(card: cardToEdit) { updatedCard in
                    if let index = file.cards.firstIndex(where: { $0.id == updatedCard.id }) {
                        file.cards[index] = updatedCard  // تحديث البطاقة في القائمة
                    }
                }
            }
        }
        // التنبيه الذي يطلب تأكيد الحذف
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("هل أنت متأكد؟"),
                message: Text("هل ترغب في حذف هذه البطاقة؟ هذه العملية لا يمكن التراجع عنها."),
                primaryButton: .destructive(Text("حذف")) {
                    if let cardToDelete = cardToDelete {
                        deleteCard(cardToDelete)
                    }
                },
                secondaryButton: .cancel(Text("إلغاء"))
            )
        }
        // نافذة إدخال الرقم السري
        .sheet(isPresented: $showPasswordPrompt) {
            VStack(spacing: 20) {
                Text("أدخل الرقم السري")
                    .font(.headline)
                
                // حقل النص الذي يمكن رؤية الباسورد فيه
                HStack {
                    if showPassword {
                        TextField("الرقم السري", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .multilineTextAlignment(.center)  // نص في المنتصف
                            .padding(.horizontal)
                    } else {
                        SecureField("الرقم السري", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .multilineTextAlignment(.center)  // نص في المنتصف
                            .padding(.horizontal)
                    }
                }
                
                if passwordError {
                    Text("الرقم السري غير صحيح.")
                        .foregroundColor(.red)
                }

                Button(action: {
                    // تحقق من الرقم السري
                    if password == correctPassword {
                        showButtonsForCard = cardToEdit  // إذا كان الرقم السري صحيحًا، نعرض الأزرار
                        showPasswordPrompt = false  // إغلاق نافذة الرقم السري
                    } else {
                        passwordError = true  // الرقم السري خاطئ
                    }
                }) {
                    Text("تأكيد")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                // زر للتبديل بين إظهار وإخفاء كلمة المرور
                Button(action: {
                    showPassword.toggle()
                }) {
                    Text(showPassword ? "إخفاء الرقم السري" : "إظهار الرقم السري")
                        .font(.body)
                        .foregroundColor(.blue)
                }
                .padding(.top)
            }
            .padding()
        }
        .environment(\.layoutDirection, .rightToLeft) // محاذاة الواجهة من اليمين لليسار
    }
    
    private func loadCards() {
        // يمكنك هنا إضافة طريقة لتحميل البطاقات إذا كان هناك حاجة
    }

    // دالة لحذف البطاقة
    private func deleteCard(_ card: Card) {
        if let index = file.cards.firstIndex(where: { $0.id == card.id }) {
            file.cards.remove(at: index)
        }
        
        modelContext.delete(card)
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting card: \(error.localizedDescription)")
        }
    }
}
