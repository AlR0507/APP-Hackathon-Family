//
//  phrase.swift
//  Family+
//
//  Created by CETYS Universidad  on 14/10/25.
//

//
//  Phrase.swift
//  Family+
//
//  Created by CETYS Universidad on 14/10/25.
//

import SwiftUI

struct Phrase: View {
    var body: some View {
        Context()
    }
}

struct Context: View {
    @State private var textOpacity: Double = 0
    @State private var navigateToNext = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con degradado similar al de tu imagen
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.0, blue: 0.0),   // tono oscuro vino
                        Color(red: 0.1, green: 0.05, blue: 0.0),  // transición suave
                        Color(red: 0.25, green: 0.15, blue: 0.0)  // toque dorado/ámbar al fondo
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Texto con animación
                Text("Porque al cuidar a cada familia, hacemos del fútbol una experiencia para todos.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .opacity(textOpacity)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 1, y: 2)

                // Navegación automática
                NavigationLink(
                    destination: Family().navigationBarBackButtonHidden(true),
                    isActive: $navigateToNext
                ) {
                    EmptyView()
                }
            }
            .onAppear {
                // Animación de aparición
                withAnimation(.easeIn(duration: 3.0)) {
                    textOpacity = 1.0
                }

                // Transición después de unos segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    navigateToNext = true
                }
            }
        }
    }
}

#Preview {
    Phrase()
}
