import SwiftUI

struct JudgesView: View {
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
                if hasSearched && selectedJudges == nil {
                    Text(errorMessage ?? "No se encontró ese hack.")
                        .foregroundColor(.red)
                        .font(.title)
                        .padding()
                    Text("Por favor vuelve a ingresar la clave del hack:")
                        .font(.title)
                        .padding()

                    TextField("Ingrese la clave del Hack", text: $hackClaveInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocorrectionDisabled(true)
                        .onSubmit {
                            fetchHackData()
                        }

                    Button(action: {
                        fetchHackData()
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
                } else if selectedJudges != nil {
                    Text("Bienvenido a \(hackData.nombre), por favor selecciona tu nombre:")
                        .font(.title)
                        .padding()

                    List(selectedJudges!.sorted(), id: \.self) { judge in
                        Button(action: {
                            selectedJudge = judge
                        }) {
                            Text(judge)
                                .font(.title2)
                                .padding()
                                .background(selectedJudge == judge ? Color.blue.opacity(0.2) : Color.clear) 
                                .cornerRadius(8)
                        }
                    }

                    NavigationLink(destination: JudgeHomeView(hackClaveInput: hackClaveInput, selectedJudge: selectedJudge, nombreHack: hackData.nombre, isActive: hackData.isActive)) {
                        Text("Presiona aquí, para comenzar a calificar")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedJudge == "Selecciona un juez" ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(selectedJudge == "Selecciona un juez")
                    .padding()
                } else {
                    // Mensaje para ingresar la clave del hack
                    Text("Por favor ingresa la clave del hack:")
                        .font(.title)
                        .padding()

                    TextField("Ingrese la clave del Hack", text: $hackClaveInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocorrectionDisabled(true)
                        .onSubmit {
                            fetchHackData()
                        }

                    Button(action: {
                        fetchHackData()
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

                Spacer()
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
                fetchJudges()
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
