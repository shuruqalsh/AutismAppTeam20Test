import SwiftUI
import SwiftData

struct FilesScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var files: [File] = []
    @State private var showingNewFileSheet = false
    @State private var showingEditFileSheet = false
    @State private var fileToEdit: File?
    @State private var showingDeleteConfirmation = false
    @State private var fileToDelete: File?
    @State private var showPasswordPrompt = false
    @State private var password = ""
    @State private var passwordError = false
    @State private var showPassword = false
    @State private var isPasswordCorrect = false
    @State private var isEditingMode = false
    
    @FocusState private var focusedField: Int? // هذا سيتحكم في التركيز بين الحقول
    
    @State private var digit1: String = ""
    @State private var digit2: String = ""
    @State private var digit3: String = ""
    @State private var digit4: String = ""

    let correctPassword = "1234"
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FFF6E8").ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
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
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color(hex: "#FFC967"))
                                    .cornerRadius(43)
                            } else {
                                Image("Line")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding()
                            }
                        }
                    }
                    .padding()
                    .padding(.top, -50)
                    Spacer()

                    HStack {
                        Button(action: {
                            showingNewFileSheet.toggle()
                        }) {
                            Image("plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                        }
                        Spacer()
                    }

                    .sheet(isPresented: $showingNewFileSheet) {
                        NewFile(files: $files)
                    }
                    .padding([.leading], 20)
                    .padding(.top, -73)
                    Spacer()

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach($files) { $file in
                                VStack {
                                    NavigationLink(destination: CardsListScreen(file: $file)) {
                                        FileView(file: file)
                                            .padding()
                                    }

                                    if isEditingMode {
                                        HStack(spacing: 20) {
                                            Button(action: {
                                                fileToEdit = file
                                                showingEditFileSheet.toggle()
                                            }) {
                                                Image(systemName: "pencil")
                                                    .font(.system(size: 22, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(12)
                                                    .background(Color.blue)
                                                    .clipShape(Circle())
                                            }
                                            .frame(width: 44, height: 44)

                                            Button(action: {
                                                fileToDelete = file
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
                .onAppear {
                    loadFiles()
                }

                .sheet(isPresented: $showingEditFileSheet) {
                    if let fileToEdit = fileToEdit {
                        EditFile(file: fileToEdit) { updatedFile in
                            if let index = files.firstIndex(where: { $0.id == updatedFile.id }) {
                                files[index] = updatedFile
                            }
                        }
                    }
                }

                .alert(isPresented: $showingDeleteConfirmation) {
                    Alert(
                        title: Text("هل أنت متأكد؟"),
                        message: Text("هل ترغب في حذف هذا الملف؟ هذه العملية لا يمكن التراجع عنها."),
                        primaryButton: .destructive(Text("حذف")) {
                            if let fileToDelete = fileToDelete {
                                deleteFile(fileToDelete)
                            }
                        },
                        secondaryButton: .cancel(Text("إلغاء"))
                    )
                }

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

                            HStack {
                                TextField("", text: $digit1)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    .focused($focusedField, equals: 0)
                                    .onChange(of: digit1) { _ in
                                        moveToNextField(current: 0)
                                        moveToPreviousField(current: 0)
                                    }
                                    .foregroundColor(.black)

                                TextField("", text: $digit2)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    .focused($focusedField, equals: 1)
                                    .onChange(of: digit2) { _ in
                                        moveToNextField(current: 1)
                                        moveToPreviousField(current: 1)
                                    }
                                    .foregroundColor(.black)

                                TextField("", text: $digit3)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    .focused($focusedField, equals: 2)
                                    .onChange(of: digit3) { _ in
                                        moveToNextField(current: 2)
                                        moveToPreviousField(current: 2)
                                    }
                                    .foregroundColor(.black)

                                TextField("", text: $digit4)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    .focused($focusedField, equals: 3)
                                    .onChange(of: digit4) { _ in
                                        moveToNextField(current: 3)
                                        moveToPreviousField(current: 3)
                                    }
                                    .foregroundColor(.black)
                            }

                            if passwordError {
                                Text("الرقم السري غير صحيح.")
                                    .foregroundColor(.red)
                            }

                            Button(action: {
                                // تحويل الأرقام المدخلة إلى الإنجليزية قبل المقارنة
                                let enteredPassword = convertToEnglishDigits(digit1 + digit2 + digit3 + digit4)
                                
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
    }

    private func loadFiles() {
        do {
            let fetchDescriptor = FetchDescriptor<File>()
            let filesFetch = try modelContext.fetch(fetchDescriptor)
            files = filesFetch.sorted { $0.title < $1.title }
        } catch {
            print("Error loading files: \(error.localizedDescription)")
        }
    }

    private func deleteFile(_ file: File) {
        modelContext.delete(file)

        do {
            try modelContext.save()
            loadFiles()
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
        }
    }

    private func moveToNextField(current: Int) {
        // ننتقل إلى الحقل التالي فقط إذا كانت القيمة المدخلة غير فارغة
        if current < 3 && !getFieldValue(current: current).isEmpty {
            focusedField = current + 1
        }
    }

    private func moveToPreviousField(current: Int) {
        // إذا كان الحقل الحالي فارغًا و ليس الحقل الأول، ننتقل إلى الحقل السابق
        if current > 0 && getFieldValue(current: current).isEmpty {
            focusedField = current - 1
        }
    }

    private func getFieldValue(current: Int) -> String {
        switch current {
        case 0: return digit1
        case 1: return digit2
        case 2: return digit3
        case 3: return digit4
        default: return ""
        }
    }

    private func convertToEnglishDigits(_ input: String) -> String {
        let arabicToEnglishMapping: [Character: Character] = [
            "٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4",
            "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"
        ]
        return String(input.map { arabicToEnglishMapping[$0] ?? $0 })
    }
}
