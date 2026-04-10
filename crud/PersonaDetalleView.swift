//
//  PersonaDetalleView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct PersonaDetalleView: View {

    let persona: Persona

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Foto
                if let imagenData = persona.imagen, let uiImage = UIImage(data: imagenData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundStyle(.gray)
                }

                Text("\(persona.nombre) \(persona.apellido)")
                    .font(.title)
                    .bold()

                VStack(spacing: 0) {
                    FilaDetalle(icono: "creditcard", titulo: "Cédula", valor: persona.cedula)
                    Divider()
                    FilaDetalle(icono: "calendar", titulo: "Fecha de Nacimiento", valor: persona.fechaNacimiento.formatted(date: .long, time: .omitted))
                    Divider()
                    FilaDetalle(icono: "person", titulo: "Género", valor: persona.genero)
                    Divider()
                    FilaDetalle(icono: "envelope", titulo: "Correo", valor: persona.correo)
                    Divider()
                    FilaDetalle(icono: "phone", titulo: "Teléfono", valor: persona.telefono)
                }
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FilaDetalle: View {

    let icono: String
    let titulo: String
    let valor: String

    var body: some View {
        HStack {
            Label(titulo, systemImage: icono)
                .foregroundStyle(.secondary)
            Spacer()
            Text(valor)
        }
        .padding()
    }
}
