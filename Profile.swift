//
//  Profile.swift
//  Family+
//
//  Created by CETYS Universidad  on 09/10/25.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        ProfileView()
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                        Color.white.edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            Text("Vista de Perfil")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            // Aquí puedes agregar más contenido del perfil
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Usuario Ejemplo")
                                .font(.title2)
                            
                            Spacer()
                        }
                        .navigationBarTitle("Perfil", displayMode: .inline)
                    }
                }
            }
        }


#Preview {
    Profile()
}
