//
//  PersonaDetalleView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

/// Vista de detalle que muestra toda la información de una persona.
/// Presenta la foto de perfil con efecto Liquid Glass, el nombre completo
/// y una tarjeta con los datos personales (cédula, fecha, género, correo, teléfono).
struct PersonaDetalleView: View {

    /// La persona cuyos datos se muestran en el detalle.
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
                .padding(.horizontal)
                .glassEffect(in: .rect(cornerRadius: 16))
            }
            .padding(.vertical)
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Vista reutilizable que muestra una fila de información con icono, título y valor.
/// Se utiliza dentro de la vista de detalle para cada campo de datos.
struct FilaDetalle: View {

    /// Nombre del icono SF Symbol a mostrar.
    let icono: String
    /// Etiqueta descriptiva del campo (ej: "Cédula", "Correo").
    let titulo: String
    /// Valor del campo a mostrar.
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
