
import Foundation
import CoreLocation

extension DataStore {
    /// Servicios familiares cercanos al Estadio BBVA (Monterrey)
    /// Coordenadas aproximadas para desarrollo; puedes ajustar según datos reales.
    static func familyServicesNearBBVA() -> [FamilyService] {
        [
            // 🌳 Parques y áreas recreativas
            FamilyService(
                name: "Parque La Pastora",
                category: .parque,
                coordinate: CLLocationCoordinate2D(latitude: 25.6739, longitude: -100.2389),
                description: "Área verde amplia junto al estadio, con zonas de descanso y juegos.",
                amenities: ["Área de juegos", "Sombras", "Baños públicos"],
                hours: "6:00 a 19:00",
                phone: nil
            ),
            FamilyService(
                name: "Zoológico La Pastora",
                category: .parque,
                coordinate: CLLocationCoordinate2D(latitude: 25.6718, longitude: -100.2406),
                description: "Espacio familiar con animales, áreas verdes y zonas de picnic.",
                amenities: ["Juegos infantiles", "Baños", "Estacionamiento"],
                hours: "9:00 a 17:00",
                phone: nil
            ),

            // 🏥 Clínicas y servicios médicos
            FamilyService(
                name: "Hospital Christus Muguerza Sur",
                category: .clinica,
                coordinate: CLLocationCoordinate2D(latitude: 25.6709, longitude: -100.2437),
                description: "Centro médico con área pediátrica, urgencias y farmacia interna.",
                amenities: ["Urgencias 24h", "Pediatría", "Farmacia"],
                hours: "Abierto 24 horas",
                phone: "81 8123 0300"
            ),
            FamilyService(
                name: "Clínica de Emergencias La Pastora",
                category: .clinica,
                coordinate: CLLocationCoordinate2D(latitude: 25.6751, longitude: -100.2452),
                description: "Clínica cercana al estadio para atención de primeros auxilios y emergencias menores.",
                amenities: ["Atención rápida", "Estacionamiento", "Farmacia anexa"],
                hours: "8:00 a 22:00",
                phone: "81 8346 9020"
            ),
            FamilyService(
                name: "Farmacias del Ahorro La Pastora",
                category: .farmacia,
                coordinate: CLLocationCoordinate2D(latitude: 25.6768, longitude: -100.2408),
                description: "Medicamentos, pañales y artículos de higiene infantil.",
                amenities: ["Pañales y fórmulas", "Medicamentos pediátricos", "Estacionamiento"],
                hours: "8:00 a 23:00",
                phone: "81 8399 1111"
            ),
            FamilyService(
                name: "Farmacia Guadalajara Eloy Cavazos",
                category: .farmacia,
                coordinate: CLLocationCoordinate2D(latitude: 25.6763, longitude: -100.2423),
                description: "Farmacia 24 horas con servicio de auto y venta de productos para bebés.",
                amenities: ["AutoFarmacia", "Productos para bebé", "Servicio 24h"],
                hours: "Abierto 24 horas",
                phone: "81 8124 3030"
            ),

            // 🛒 Supermercados y tiendas
            FamilyService(
                name: "H-E-B Eloy Cavazos",
                category: .supermercado,
                coordinate: CLLocationCoordinate2D(latitude: 25.6769, longitude: -100.2359),
                description: "Supermercado con sección de bebés, comida preparada y baños familiares.",
                amenities: ["Sillas altas", "Área de comida", "Sección bebés"],
                hours: "7:00 a 22:00",
                phone: "81 8030 4000"
            ),
            FamilyService(
                name: "OXXO La Pastora",
                category: .supermercado,
                coordinate: CLLocationCoordinate2D(latitude: 25.6748, longitude: -100.2411),
                description: "Tienda de conveniencia con snacks, pañales y bebidas.",
                amenities: ["Pañales", "Snacks", "Cajero automático"],
                hours: "Abierto 24 horas",
                phone: nil
            ),

            // ☕ Cafeterías y restaurantes
            FamilyService(
                name: "Cafetería Local La Pastora",
                category: .cafeteria,
                coordinate: CLLocationCoordinate2D(latitude: 25.6726, longitude: -100.2434),
                description: "Bebidas y snacks; cuenta con cambiador en baño y área infantil pequeña.",
                amenities: ["WiFi", "Cambiador", "Sillas altas"],
                hours: "7:00 a 21:00",
                phone: nil
            ),
            FamilyService(
                name: "Starbucks Eloy Cavazos",
                category: .cafeteria,
                coordinate: CLLocationCoordinate2D(latitude: 25.6773, longitude: -100.2367),
                description: "Cafetería moderna con área familiar y baños limpios.",
                amenities: ["WiFi", "Baños", "Área con aire acondicionado"],
                hours: "6:00 a 22:00",
                phone: "81 8359 1200"
            ),
            FamilyService(
                name: "Restaurante Las Pampas BBQ",
                category: .cafeteria,
                coordinate: CLLocationCoordinate2D(latitude: 25.6754, longitude: -100.2458),
                description: "Restaurante familiar con menú infantil y zona de juegos.",
                amenities: ["Menú infantil", "Área de juegos", "Baños amplios"],
                hours: "12:00 a 23:00",
                phone: "81 8098 9901"
            ),

            // 🅿️ Estacionamientos
            FamilyService(
                name: "Estacionamiento Oficial BBVA",
                category: .estacionamiento,
                coordinate: CLLocationCoordinate2D(latitude: 25.6731, longitude: -100.2461),
                description: "Estacionamiento del estadio con espacios amplios, accesibles y seguridad privada.",
                amenities: ["Rampas", "Seguridad", "Cajones amplios"],
                hours: "Durante eventos",
                phone: nil
            ),
            FamilyService(
                name: "Estacionamiento La Pastora Norte",
                category: .estacionamiento,
                coordinate: CLLocationCoordinate2D(latitude: 25.6741, longitude: -100.2431),
                description: "Estacionamiento público con acceso directo al parque y zonas familiares.",
                amenities: ["Rampas", "Sombra", "Seguridad"],
                hours: "6:00 a 22:00",
                phone: nil
            )
        ]
    }
}
