//
//  TeamViewAdmin.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 24/04/24.
//

import SwiftUI
import Charts

struct TeamAdminView: View {
    let dummyData = ["Elemento 1", "Elemento 2", "Elemento 3", "Elemento 4", "Elemento 5", "Elemento 6","Elemento 7", "Elemento 8", "Elemento 9" ]
    @State private var products: [Product] = [
        .init(title: "Annual", revenue: 0.7),
        .init(title: "Monthly", revenue: 0.2),
        .init(title: "Lifetime", revenue: 0.1)
    ]
    var body: some View {
        GeometryReader{ geo in
            HStack(spacing: 0) {
                VStack(alignment: .leading){
                    Text("Titulo")
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
                            Text(data)
                                .padding()
                        }
                    }
                    .listRowSpacing(8)
                }
            }
        }
    }
}

#Preview {
    TeamAdminView()
}
