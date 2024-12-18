
import SwiftUI
/// `HomeAdminView` es la vista principal del administrador donde se visualizan los hackathons disponibles.
/// Permite al administrador acceder a los hackathons existentes, ver sus detalles, y crear nuevos hackathons.
struct HomeAdminView: View {
    @EnvironmentObject var hackData: HacksViewModel
    @State var isActivated: Bool = false
    @StateObject private var formData = FormDataViewModel(
        listaRubros: RubroViewModel(),
        listaEquipos: EquipoViewModel(),
        listaJueces: JuezViewModel()
    )
    @StateObject private var listaRubros = RubroViewModel()
    @StateObject  private var listaEquipos = EquipoViewModel()
    @StateObject private var listaJueces = JuezViewModel()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if hackData.hacks.isEmpty {
                        if hackData.isLoading {
                            ProgressView("Cargando...")
                                .font(.largeTitle)
                                .padding()
                        } else {
                            Text("No hay hacks disponibles")
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(.gray)
                        }
                    } else {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(hackData.hacks) { hack in
                                NavigationLink(destination: HackView(hack: hack)) {
                                    HackRow(hack: hack)
                                        .environmentObject(hackData)
                                }
                            }
                        }
                        .padding()
                    }

                    Spacer()
                }
                .navigationTitle("Tus Hackatons")
                .padding(.bottom, 20)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isActivated = true
                        } label: {
                            Label("Nuevo Hackathon", systemImage: "plus")
                                .font(.title)
                                .bold()
                                .padding()
                        }
                        .buttonStyle(MainViewButtonStyle())
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $isActivated) {
                // Pasa formData a la vista AddHackView
                AddHackView(formData: formData, listaHacks: hackData, listaRubros: listaRubros, listaEquipos: listaEquipos, listaJueces: listaJueces)
            }
        }
        .onAppear {
            hackData.fetchHacks()
        }
    }
}


#Preview {
    HomeAdminView()
}
