import SwiftUI

struct JudgesView: View {
    @State private var showModal = false
    @State private var hackClaveInput = ""
    @State private var selectedJudges: [String]?
    @State private var selectedJudge: String = "Selecciona un juez"
    @State private var errorMessage: String?
    @State private var hasSearched = false
    @ObservedObject var viewModel = HacksViewModel()
    @StateObject var hackData = HacksViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if let judges = selectedJudges {
                    Text("Bienvenido a \(hackData.nombre), por favor escoge tu nombre:")
                        .font(.title)
                        .padding()
                    List(judges.sorted(), id: \.self) { judge in
                        Button(action: {
                            selectedJudge = judge
                        }) {
                            Text(judge)
                                .font(.title2)
                                .padding()
                        }
                    }
                    NavigationLink(destination: JudgeHomeView(hackClaveInput: hackClaveInput, selectedJudge: selectedJudge, nombreHack: hackData.nombre, isActive: hackData.isActive)) {
                        Text("Continuar como \(selectedJudge)")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedJudge == "Selecciona un juez" ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(selectedJudge == "Selecciona un juez")
                    .padding()
                } else if hasSearched {
                    Text(errorMessage ?? "No se encontró ese hack.")
                        .foregroundColor(.red)
                        .font(.title)
                        .padding()
                } else {
                    Text("Realiza una búsqueda del hackathon.")
                        .font(.title)
                        .padding()
                }

                Spacer()

                Button {
                    showModal.toggle()
                } label: {
                    Label("Buscar Hackathon", systemImage: "search")
                        .font(.title)
                        .bold()
                        .padding()
                        .foregroundColor(.blue)
                }
                .popover(isPresented: $showModal) {
                    VStack(spacing: 20) {
                        TextField("Ingrese la clave del Hack", text: $hackClaveInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: {
                            fetchHackData()
                            showModal = false
                        }) {
                            Text("Buscar Jueces")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .padding()
                    .frame(width: 300)
                }
            }
            .onAppear {
                viewModel.fetchHacks()
            }
        }
    }

    private func fetchHackData() {
        hackData.fetchHack(byKey: hackClaveInput) { result in
            switch result {
            case .success(let hack):
                hackData.nombre = hack.nombre
                hackData.isActive = hack.estaActivo
                fetchJudges() // Llama a fetchJudges después de obtener el hack
            case .failure:
                selectedJudges = nil
                errorMessage = "No se ha encontrado ese hack."
                hasSearched = true
            }
        }
    }

    private func fetchJudges() {
        viewModel.getJudges(for: hackClaveInput) { result in
            switch result {
            case .success(let judges):
                if judges.isEmpty {
                    selectedJudges = nil
                    errorMessage = "No se han encontrado jueces para el hack."
                } else {
                    selectedJudges = judges
                    errorMessage = nil
                }
                hasSearched = true
            case .failure:
                selectedJudges = nil
                errorMessage = "No se ha encontrado ese hack."
                hasSearched = true
            }
        }
    }
}

struct JudgesView_Previews: PreviewProvider {
    static var previews: some View {
        JudgesView()
    }
}
