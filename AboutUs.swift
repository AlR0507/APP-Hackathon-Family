//
//  AboutUs.swift
//  Family+
//
//  Created by CETYS Universidad  on 17/10/25.
//

import SwiftUI

struct About: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo degradado azul
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.12, green: 0.28, blue: 0.55),
                        Color(red: 0.20, green: 0.45, blue: 0.75)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // ===== Encabezado =====
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("Sobre Nosotros")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()
                        Color.clear.frame(width: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    .padding(.bottom, 20)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Sección principal
                            Text("Nuestra Misión")
                                .font(.title2.bold())
                                .foregroundColor(.blue)
                            Text("En Family+, creemos que el fútbol debe ser una experiencia accesible, segura y disfrutable para todas las familias. Nuestro objetivo es conectar a los aficionados con espacios familiares, servicios inclusivos y experiencias únicas dentro y fuera de los estadios del Mundial 2026.")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .lineSpacing(4)

                            Divider()

                            Text("Nuestra Historia")
                                .font(.title2.bold())
                                .foregroundColor(.blue)
                            Text("Family+ nació como un proyecto universitario en CETYS Universidad, impulsado por la visión de crear una aplicación que promueva la inclusión y la comodidad de las familias en los grandes eventos deportivos.")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .lineSpacing(4)

                            Divider()

                            Text("Nuestro Equipo")
                                .font(.title2.bold())
                                .foregroundColor(.blue)
                            Text("Somos un equipo multidisciplinario de estudiantes apasionados por la tecnología, el diseño y el deporte. Combinamos nuestras habilidades para desarrollar una herramienta que une a las familias a través del fútbol.")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .lineSpacing(4)

                            NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                           isActive: $navigateToHome) { EmptyView() }

                            Button(action: {
                                navigateToHome = true
                            }) {
                                Text("Volver a Inicio")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.15, green: 0.35, blue: 0.65))
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .padding(.top, 40)
                            }
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    About()
}
