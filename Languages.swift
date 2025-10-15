//
//  Languages.swift
//  Family+
//
//  Created by CETYS Universidad  on 14/10/25.
//

import SwiftUI

struct Languages: View {
    @State private var selectedLanguage = "Español"
    @State private var languages = ["Español", "Inglés", "Francés", "Árabe", "Portugués"]
    @State private var showingAddLanguage = false
    @State private var navigateToSettings = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Fondo azul
            Color(red: 0.2, green: 0.4, blue: 0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con botón de regreso
                HStack {
                    NavigationLink(destination: Settings().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToSettings) {
                        EmptyView()
                    }
                    Button(action: {
                        navigateToSettings = true
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    Text("Idiomas")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Espacio para balancear el título
                    Color.clear
                        .frame(width: 44)
                        .padding(.trailing, 20)
                }
                .padding(.vertical, 20)
                
                // Contenedor blanco con esquinas redondeadas
                VStack(alignment: .leading, spacing: 0) {
                    // Texto informativo
                    Text("Elige el idioma predeterminado tanto para ver el sitio, tus tutoriales y notificaciones")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                        .padding(.bottom, 20)
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    // Título de sección
                    Text("Idioma del sitio")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    // Lista de idiomas
                    VStack(spacing: 0) {
                        ForEach(languages, id: \.self) { language in
                            Button(action: {
                                selectedLanguage = language
                            }) {
                                HStack {
                                    Text(language)
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(selectedLanguage == language ? Color(red: 0.85, green: 0.9, blue: 0.95) : Color.white)
                            }
                            
                            if language != languages.last {
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                                    .padding(.leading, 20)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.top, 20)
                }
                .background(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
        }
        .navigationBarHidden(true)
    }
}

// Extensión para redondear esquinas específicas
extension View {
    func cornerRadius1(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner1(radius: radius, corners: corners))
    }
}

struct RoundedCorner1: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    Languages()
}
