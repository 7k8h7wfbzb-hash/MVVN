//
//  EmpleadoDetalleView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct EmpleadoDetalleView: View {

    let empleado: Empleado

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let persona = empleado.persona {
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
                    if let persona = empleado.persona {
                        FilaDetalle(icono: "creditcard", titulo: "Cédula", valor: persona.cedula)
                        Divider()
                        FilaDetalle(icono: "envelope", titulo: "Correo", valor: persona.correo)
                        Divider()
                        FilaDetalle(icono: "phone", titulo: "Teléfono", valor: persona.telefono)
                        Divider()
                    }
                    FilaDetalle(icono: "briefcase", titulo: "Cargo", valor: empleado.cargo)
                    Divider()
                    FilaDetalle(icono: "building.2", titulo: "Departamento", valor: empleado.departamento)
                    Divider()
                    FilaDetalle(icono: "dollarsign.circle", titulo: "Salario", valor: String(format: "$%.2f", empleado.salario))
                    Divider()
                    FilaDetalle(icono: "calendar", titulo: "Fecha de Ingreso", valor: empleado.fechaIngreso.formatted(date: .long, time: .omitted))
                }
                .padding(.horizontal)
                .glassEffect(in: .rect(cornerRadius: 16))
            }
            .padding(.vertical)
        }
        .navigationTitle("Detalle Empleado")
        .navigationBarTitleDisplayMode(.inline)
    }
}
