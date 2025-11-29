

struct TodofukenView : View{
    @State private var viewModel = TodofukenViewModel()
    @State private var showingAddSheet = false
    var body : some View {
        NavigationStack(path: $viewModel.path) {
            TodofukenListView(viewModel: viewModel)
                .navigationDestination(for: Todofuken.self) { todofuken in
                    TodofukenDetailView(todofuken: todofuken)
                }
                .navigationTitle("도도부현")
                .task {
                    await viewModel.loadTodofuken()
                }
                .refreshable {
                    await viewModel.loadTodofuken()
                }
                .toolbar {
                    Button {
                        showingAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    TodofukenAddView(viewModel: viewModel)
                }
        }
    }
}

struct TodofukenListView: View {
    let viewModel : TodofukenViewModel
    
    var groupedTodofukens: [Region: [Todofuken]] {
        Dictionary(grouping: viewModel.todofuken, by: { $0.region })
    }
    
    var body : some View {
        List { 
            ForEach(Region.allCases, id: \.self) { region in
            if let items = groupedTodofukens[region], !items.isEmpty {
                Section(header: Text(region.displayName)) {
                    ForEach(items, id: \.self) { todofuken in
                        NavigationLink(value: todofuken) {
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(todofuken.name_ko)
                                        .font(.headline)
                                    Text(todofuken.name_ja)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            }
            }
        }
    }
}

struct TodofukenDetailView: View {
    let todofuken: Todofuken
    var body : some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                Text(todofuken.description)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                    .padding(.bottom, 10)
            }
            .padding()
        }
        .navigationTitle(todofuken.name_ko)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct TodofukenAddView : View {
    let viewModel : TodofukenViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var name_ko = ""
    @State var name_ja = "○○都／道／府／県"
    @State var rating = 3
    @State var description = ""
    @State var url = ""
    @State var region = Region.unknown
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("도도부현 정보 *")) {
                    TextField("한국 이름 *", text: $name_ko)
                    TextField("일본 이름(한자)", text: $name_ja)
                }

                Section(header: Text("지역 *")) {
                    Picker("지역 선택", selection: $region) {
                        ForEach(Region.allCases.filter { $0 != .unknown }, id: \.self) { region in
                            Text(region.rawValue)
                                .tag(region)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("설명 *")) {
                    TextEditor(text: $description)
                        .frame(height: 150)
                }

                Section(header: Text("선호도")) {
                    Picker("별점", selection: $rating) {
                        ForEach(1...5, id: \.self) { score in
                            Text("\(score)점")
                                .tag(score)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("관련 URL")) {
                    TextField("URL 입력", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        Task {
                            await viewModel.addTodofuken(
                                Todofuken(id: UUID(), name_ja: name_ja, name_ko: name_ko, description: description, region: region, url: url,
                                          rating: rating)
                            )
                            dismiss()
                        }
                    }
                    .disabled(name_ko.isEmpty || description.isEmpty || name_ja.isEmpty 
                    || region == .unknown)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
}