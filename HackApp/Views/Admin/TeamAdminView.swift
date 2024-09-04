//
//  TeamViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 24/04/24.
//

import SwiftUI
import Charts

struct TeamAdminView: View {
    let dummyData = ["Juez 1", "Juez 2", "Juez 3", "Juez 4" ]
    @State private var products: [Product] = [
        .init(title: "Annual", revenue: 0.7),
        .init(title: "Monthly", revenue: 0.2),
        .init(title: "Lifetime", revenue: 0.1)
    ]
    var body: some View {
        GeometryReader{ geo in
            HStack(spacing: 0) {
                VStack(alignment: .leading){
                    Text("Equipo X")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Spacer()
                    HStack{
                        Chart(products) { product in
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: product.title),
                                    product.revenue
                                )
                            )
                            .foregroundStyle(
                                by: .value(
                                    Text(verbatim: product.title),
                                    product.title
                                )
                            )
                        }
                        .padding()
                        Chart(products) { product in
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: product.title),
                                    product.revenue
                                )
                            )
                            .foregroundStyle(
                                by: .value(
                                    Text(verbatim: product.title),
                                    product.title
                                )
                            )
                        }
                        .padding()
                        Chart(products) { product in
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: product.title),
                                    product.revenue
                                )
                            )
                            .foregroundStyle(
                                by: .value(
                                    Text(verbatim: product.title),
                                    product.title
                                )
                            )
                        }
                        .padding()
                    }
                    Spacer()
                }
                Divider()
                VStack{
                    List{
                        ForEach(dummyData, id: \.self){data in
                            HStack{
                                Text(data)
                                    .bold()
                                    .padding()
                                Spacer()
                                Text("\(String(Int.random(in: 0..<100))) / 100")
                                    .bold()
                                
                            }
                        }
                    }
                    .listRowSpacing(8)
                    Divider()
                    Text("Total : 91/100")
                        .bold()
                        .font(.largeTitle)
                        .frame(height: geo.size.height * 0.5)
                }
            }
        }
    }
}

#Preview {
    TeamAdminView()
}
