//
//  PerfilView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct PerfilView: View {

    var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let empleado = authViewModel.empleadoActual, let persona = empleado.persona {
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
                            FilaDetalle(icono: "person.badge.key", titulo: "Usuario", valor: empleado.usuario)
                            Divider()
                            FilaDetalle(icono: "briefcase", titulo: "Cargo", valor: empleado.cargo)
                            Divider()
                            FilaDetalle(icono: "building.2", titulo: "Departamento", valor: empleado.departamento)
                            Divider()
                            FilaDetalle(icono: "envelope", titulo: "Correo", valor: persona.correo)
                        }
                        .padding(.horizontal)
                        .glassEffect(in: .rect(cornerRadius: 16))
                    }

                    Button(role: .destructive) {
                        authViewModel.cerrarSesion()
                    } label: {
                        Label("Cerrar Sesión", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Mi Perfil")
        }
    }
}
