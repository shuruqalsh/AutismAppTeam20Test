import SwiftUI
import SwiftData

struct CardsListScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var file: File
    
    // MARK: - حالة المتغيرات
    @State private var showingNewCardSheet = false
    @State private var showingEditCardSheet = false
    @State private var cardToEdit: Card?
    @State private var showingDeleteConfirmation = false
    @State private var cardToDelete: Card?
    @State private var showPasswordPrompt = false
    @State private var password = ""
    @State private var passwordError = false
    @State private var showPassword = false
    @State private var isPasswordCorrect = false
    @State private var isEditingMode = false
    
    @FocusState private var focusedField: Int? // التحكم في التركيز بين الحقول
    
    let correctPassword = "1234"  // الرقم السري الصحيح
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - واجهة المستخدم (body)
    var body: some View {
        VStack {
            ZStack {
                Color(hex: "#FFF6E8").ignoresSafeArea()

                VStack {
                    HStack{
                        Button(action: {
                            if isEditingMode {
                                isEditingMode = false
                            } else {
                                showPasswordPrompt = true
                            }
                        }) {
                            if isEditingMode {
                                Image(systemName: "checkmark")
                                    .frame(width: 50, height: 50)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(Color(hex: "#FFF6E8"))
                                    .background(Color(hex: "#FFC967"))
                                    .cornerRadius(43)
                            } else {
                                Image("Line")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .padding()
                        
                        Spacer()
                        
                        
                        
                        // زر إضافة بطاقة جديدة
                        Button(action: {
                            showingNewCardSheet.toggle()
                        }) {
                            Image("plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                        }
                        .padding()
                        .padding(.top, 9)
                        .sheet(isPresented: $showingNewCardSheet) {
                            NewCard(file: $file)
                        }
                    }
                    
                    // عرض البطاقات باستخدام LazyVGrid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(file.cards) { card in
                                VStack {
                                    CardView(card: card)  // عرض البطاقة
                                        .padding()

                                    // زر لتبديل وضع التعديل
                        
                                    // عرض أزرار التعديل والحذف في وضع التعديل
                                    if isEditingMode {
                                        HStack(spacing: 16) {
                                            // زر تعديل
                                            Button(action: {
                                                cardToEdit = card
                                                showingEditCardSheet.toggle()
                                            }) {
                                                Image(systemName: "pencil")
                                                    .font(.system(size: 22, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(12)
                                                    .background(Color.blue)
                                                    .clipShape(Circle())
                                            }
                                            .frame(width: 44, height: 44)

                                            // زر حذف
                                            Button(action: {
                                                cardToDelete = card
                                                showingDeleteConfirmation = true
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 22, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(12)
                                                    .background(Color.red)
                                                    .clipShape(Circle())
                                            }
                                            .frame(width: 44, height: 44)
                                        }
                                        .padding(.top, 8)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(file.title) // عنوان الشاشة
            .onAppear {
                loadCards() // تحميل البطاقات عند ظهور الشاشة
            }

            // MARK: - النوافذ المنبثقة (Sheets)
            .sheet(isPresented: $showingEditCardSheet) {
                if let cardToEdit = cardToEdit {
                    EditCard(card: cardToEdit) { updatedCard in
                        if let index = file.cards.firstIndex(where: { $0.id == updatedCard.id }) {
                            file.cards[index] = updatedCard
                        }
                    }
                }
            }

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
                ZStack {
                    Color(hex: "#FFF6E8").ignoresSafeArea()

                    VStack {
                        Image("IpadGirl")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 240)

                        Text("هنا يمكنكم اضافة بطاقات جديدة وتعديل بطاقاتكم!\nالرقم السري : 1234.")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.headline)

                        // حقل إدخال الرقم السري
                        TextField("أدخل الرقم السري", text: $password)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 200, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            .focused($focusedField, equals: 0)
                            .onChange(of: password) { _ in
                                if password.count > 4 {
                                    password = String(password.prefix(4))
                                }
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        if passwordError {
                            Text("الرقم السري غير صحيح.")
                                .foregroundColor(.red)
                        }

                        Button(action: {
                            let enteredPassword = convertToEnglishDigits(password)
                            if enteredPassword == correctPassword {
                                isPasswordCorrect = true
                                showPasswordPrompt = false
                                isEditingMode = true
                            } else {
                                passwordError = true
                            }
                        }) {
                            Text("تأكيد")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                        Text("الرقم السري يهدف لضمان عدم تعديل الإعدادات من قبل الطفل، مما يساعد في الحفاظ على استقرار التطبيق.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "#4C4C4C"))
                            .font(.headline)
                    }
                    .padding()
                }
            }
        }
    }

    // MARK: - الدوال المساعدة
    private func loadCards() {
        // تحميل البطاقات (يمكنك إضافة الكود الخاص بتحميل البيانات هنا)
    }

    private func convertToEnglishDigits(_ input: String) -> String {
        let arabicToEnglishMapping: [Character: Character] = [
            "٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4",
            "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"
        ]
        return String(input.map { arabicToEnglishMapping[$0] ?? $0 })
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

