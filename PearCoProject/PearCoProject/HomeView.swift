//
//  HomeView.swift
//  PearCoProject
//
//  Created by Alumno on 09/09/25.
//
import SwiftUI

struct HomeView: View {
    @State private var riskVM = RiskVM()
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms = false
    @State private var showTerms = false
    
    private let REGION_JALTENANGO = "f9b355d6-c40e-49c2-b0cc-526145b9b3fa"
    private let REGION_SANCRIS = "03473535-bd2e-4ea6-a5df-60c4525002a8"
    
    let sageGreen = Color(red: 176/255, green: 190/255, blue: 169/255)
    // ✅ NUEVOOO
    private enum RegionChoice: String, CaseIterable, Identifiable {
        case jaltenango = "Jaltenango de la Paz"
        case sanCris    = "San Cristóbal de las Casas"
        var id: String { rawValue }
    }
    @State private var selectedRegion: RegionChoice = .jaltenango
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    private func regionID(for choice: RegionChoice) -> String {
        choice == .jaltenango ? REGION_JALTENANGO : REGION_SANCRIS
    }

    // ✅ NUEVO: utilidades para renderizar la tabla bonita
    private let monthNames = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    private var currentMonthIndex: Int { Calendar.current.component(.month, from: Date()) - 1 }
    private func categoryColor(_ cat: String) -> Color {
        switch cat.lowercased() {
        case "alto":  return .red
        case "medio": return .orange
        default:      return .green
        }
    }
    private func diseaseIcon(_ d: String) -> String {
        switch d.lowercased() {
        case "roya":        return "leaf.fill"
        case "broca":       return "ant.fill"
        case "ojogallo":    return "eye.circle.fill"
        case "antracnosis": return "bolt.heart.fill"
        default:            return "exclamationmark.triangle.fill"
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                HStack(spacing: 0) {
                    // Contenido principal
                    VStack(spacing: 40) {
                        // Título
                        Text("Inicio")
                            .font(.system(size: 55, weight: .bold))
                            .foregroundColor(Color.verdeOscuro)
                        
                        Text("Toma una foto de la planta para analizar su salud")
                            .font(.title2)
                            .foregroundColor(.black)

                        ZStack {
                            Image("planta")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 350)
                                .clipped()
                                .cornerRadius(20)
                            
                            NavigationLink(destination: CameraView()) {
                                Image(systemName: "camera")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding(30)
                                    .background(Color.verdeOscuro)
                                    .clipShape(Circle())
                            }
                        }
                        
                        NavigationLink(destination: CameraView()) {
                            Text("Tomar foto")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 500, maxHeight: 100)
                                .background(Color.verdeBoton)
                                .cornerRadius(15)
                        }
                        
                        // Gráfica
                        // ✅ NUEVO: Sección del RIESGO MENSUAL (debajo de tu gráfica)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Riesgo mensual por región")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.verdeOscuro)

                            // Controles: Región + Año
                            HStack(spacing: 12) {
                                Picker("Región", selection: $selectedRegion) {
                                    ForEach(RegionChoice.allCases) { r in
                                        Text(r.rawValue).tag(r)
                                    }
                                }
                                .pickerStyle(.segmented)

                                Stepper("Año \(selectedYear)", value: $selectedYear, in: 2020...2100)
                                    .frame(maxWidth: 240, alignment: .leading)
                            }
                            // ✅ NUEVO: sección mensual aislada para que el compilador no se ahogue
                            MonthlyRiskSection(
                                riskVM: riskVM,
                                selectedRegionName: selectedRegion.rawValue,
                                regionIDProvider: { regionID(for: selectedRegion) },
                                selectedYear: selectedYear,
                                monthNames: monthNames,
                                currentMonthIndex: currentMonthIndex,
                                categoryColor: { (cat: String) -> Color in
                                    // usar la función existente, pero con firma explícita para evitar ambigüedad
                                    self.categoryColor(cat)
                                },
                                diseaseIcon: { (d: String) -> String in
                                    self.diseaseIcon(d)
                                },
                                onRetry: {
                                    Task {
                                        await riskVM.fetchMonthly(
                                            regionID: regionID(for: selectedRegion),
                                            year: selectedYear
                                        )
                                    }
                                }
                            )
                        }
                        // ✅ FIN NUEVA sección
                        
                        Spacer()
                            .padding(.bottom, 40)
                    }
                    .padding(50)
                }

                MicrophoneButton(color: Color.verdeOscuro)
                
                // Mostrar TermsAndConditionsView como overlay si no se han aceptado
                if showTerms {
                    TermsAndConditionsView {
                        hasAcceptedTerms = true
                        showTerms = false
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .greenSidebar()
            .task { await riskVM.fetchMonthly(regionID: regionID(for: selectedRegion), year: selectedYear) }
            .refreshable { await riskVM.fetchMonthly(regionID: regionID(for: selectedRegion), year: selectedYear) }
            .onAppear {
                if !hasAcceptedTerms {
                    showTerms = true
                }
            }
            // ✅ NUEVO: recargar mensual al cambiar región/año
                        .onChange(of: selectedRegion) { _, _ in
                            Task {
                                await riskVM.fetchMonthly(
                                    regionID: regionID(for: selectedRegion),
                                    year: selectedYear
                                )
                            }
                        }
                        .onChange(of: selectedYear) { _, _ in
                            Task {
                                await riskVM.fetchMonthly(
                                    regionID: regionID(for: selectedRegion),
                                    year: selectedYear
                                )
                            }
                        }
                    }
                }
            }
// MARK: - Subview aislada (evita los errores de genéricos del ViewBuilder)
@MainActor
@ViewBuilder
private func MonthlyRiskSection(
    riskVM: RiskVM,
    selectedRegionName: String,
    regionIDProvider: () -> String,
    selectedYear: Int,
    monthNames: [String],
    currentMonthIndex: Int,
    categoryColor: @escaping (String) -> Color,
    diseaseIcon: @escaping (String) -> String,
    onRetry: @escaping () -> Void
) -> some View {
    VStack(alignment: .leading, spacing: 16) {
        // 👇 Contenido (cargado/errores/datos) en ramas cortas y claras
        if riskVM.isLoading {
            ProgressView("Cargando riesgo mensual…")
        } else if let err = riskVM.error {
            VStack(spacing: 8) {
                Text("Error: \(err)").foregroundStyle(.red)
                Button("Reintentar", action: onRetry)
            }
        } else {
            if riskVM.monthly.indices.contains(currentMonthIndex) {
                let items = riskVM.monthly[currentMonthIndex].results
                PrettyMonthTable(
                    monthName: monthNames[currentMonthIndex],
                    regionName: selectedRegionName,
                    items: items,
                    categoryColor: categoryColor,
                    diseaseIcon: diseaseIcon
                )
            } else {
                Text("Sin datos del mes actual.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
}
