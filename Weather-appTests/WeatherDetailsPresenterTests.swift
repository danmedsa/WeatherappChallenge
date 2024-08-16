//
//  WeatherDetailsPresenterTests.swift
//  Weather-appTests
//
//  Created by Daniel Medina Sada on 8/16/24.
//

import XCTest
@testable import Weather_app

final class WeatherDetailsPresenterTests: XCTestCase {
    enum TestCase {
        case weatherServiceSuccess
        case weatherServiceFail
        case fetchWeatherImageSuccess
        case locateMeAction
        case stopUpdatingLocations
    }
    
    func testWeatherServiceSuccess() throws {
        let sut = makeSUT(testCase: .weatherServiceSuccess)
        let exp = expectation(description: "fetch Weather Data Service")
        Task {
            let response = try await sut.fetchWeatherData(location: "Plano, TX")
            XCTAssertNotNil(response)
            XCTAssertEqual(response.locationName, "Plano")
            exp.fulfill()
        }
        
        wait(for: [exp])
    }
    
    func testWeatherServiceFail() {
        let sut = makeSUT(testCase: .weatherServiceFail)
        let exp = expectation(description: "fetch Weather Data Service Should Fail")
        Task {
            do {
                let _ = try await sut.fetchWeatherData(location: "Plano, TX")
                exp.fulfill()
                fatalError("Test should fail")
            } catch OWMServiceProvider.OWMError.invalidURL {
                exp.fulfill()
            }
        }
        
        wait(for: [exp])
    }
    
    func testFetchWeatherImage() throws {
        let sut = makeSUT(testCase: .fetchWeatherImageSuccess)
        let exp = expectation(description: "fetch Weather Data Service Should Succeed")
        Task {
            let data = await sut.fetchWeatherImage(with: "test")
            let stringData = String(data: data, encoding: .utf8)
            XCTAssertEqual(stringData, "ImageData")
            exp.fulfill()
        }
        wait(for: [exp])
    }
    
    func testLocateMeAction() throws {
        let sut = makeSUT(testCase: .locateMeAction)
        sut.locateMeAction()
        
        let locationManagerSpy = try XCTUnwrap(sut.locationManager as? LocationManagerSpy)
        XCTAssertEqual(locationManagerSpy.actions, [.requestWhenInUseAuth])
    }
    
    func testStopUpdatingLocation() throws {
        let sut = makeSUT(testCase: .locateMeAction)
        sut.stopUpdatingLocation()
        
        let locationManagerSpy = try XCTUnwrap(sut.locationManager as? LocationManagerSpy)
        XCTAssertEqual(locationManagerSpy.actions, [.stopUpadteLocation])
    }
}


extension WeatherDetailsPresenterTests {
    func makeSUT(testCase: TestCase) -> WeatherDetailsPresenter {
        let locationManagerSpy = LocationManagerSpy()
        let mockServiceProvider = makeServiceProvider(testCase: testCase)
        let presenter = WeatherDetailsPresenter(location: makeLocation(testCase: testCase), serviceProvider: mockServiceProvider, locationManager: locationManagerSpy)
        
        return presenter
    }
    
    func makeServiceProvider(testCase: TestCase) -> OWMServiceProviding {
        let serviceProvider = MockServiceProvider()
        switch testCase {
        case .weatherServiceFail:
            serviceProvider.throwsError = OWMServiceProvider.OWMError.invalidURL
        default:
            serviceProvider.throwsError = nil
        }
        
        return serviceProvider
    }
    
    func makeLocation(testCase: TestCase) -> String? {
        switch testCase {
        case .weatherServiceSuccess, .weatherServiceFail:
            return "Plano, TX"
            
        default:
            return nil
        }
    }
}
