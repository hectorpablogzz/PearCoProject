//
//  GetWeatherTool.swift
//  PearCoProject
//
//  Created by José Francisco González on 14/10/25.
//
/*
 import Foundation
 import WeatherKit
 import CoreLocation
 import FoundationModels
 import MapKit
 
 struct GetWeatherTool: Tool{
 let name = "obtenerClima"
 let description = "Obtener la información del clima más reciente de una ciudad"
 
 let city: City
 
 @Generable
 struct Arguments {
 @Guide(description: "La ciudad de la que se obtiene el clima")
 var city: String
 }
 
 func call(arguments: Arguments) async throws -> some ToolOutput {
 let places = try await CLGeocoder().geocodeAddressString(arguments.city)
 let weather = try await WeatherService.shared.weather(for: places.first!.location!)
 let temperature = weather.currentWeather.temperature.value
 let content = GeneratedContent(properties: ["temperatura": temperature])
 let output = ToolOutput(content)
 return output
 }
 }
 */
