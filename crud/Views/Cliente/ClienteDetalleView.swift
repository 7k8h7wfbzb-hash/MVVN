//
//  ClienteDetalleView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct ClienteDetalleView: View {

    let cliente: Cliente

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let persona = cliente.persona {
                    if let imagenData = persona.imagen, let uiImage = UIImage(data: imagenData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .glassEffect(in: .circle)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.gray)
                            .glassEffect(in: .circle)
                    }

                    Text("\(persona.nombre) \(persona.apellido)")
                        .font(.title)
                        .bold()
                }

                VStack(spacing: 0) {
                    if let persona = cliente.persona {
                        FilaDetalle(icono: "creditcard", titulo: "Cédula", valor: persona.cedula)
                        Divider()
                        FilaDetalle(icono: "envelope", titulo: "Correo", valor: persona.correo)
                        Divider()
                        FilaDetalle(icono: "phone", titulo: "Teléfono", valor: persona.telefono)
                        Divider()
                    }
                    FilaDetalle(icono: "mappin.and.ellipse", titulo: "Dirección", valor: cliente.direccion)
                    Divider()
                    FilaDetalle(icono: "star", titulo: "Tipo de Cliente", valor: cliente.tipoCliente)
                }
                .padding(.horizontal)
                .glassEffect(in: .rect(cornerRadius: 16))
            }
            .padding(.vertical)
        }
        .navigationTitle("Detalle Cliente")
        .navigationBarTitleDisplayMode(.inline)
    }
}
