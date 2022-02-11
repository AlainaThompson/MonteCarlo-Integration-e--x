//
//  MonteCarlo Int.swift
//  MonteCarlo Integration
//
//  Created by Alaina Thompson on 2/4/22.
//
import Foundation
import SwiftUI
import Darwin

class MonteCarloInt: NSObject, ObservableObject {
    
    @MainActor @Published var insideData = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    @Published var totalGuessesString = ""
    @Published var guessesString = ""
    @Published var eMinusXString = ""
    @Published var enableButton = true
    var e = Darwin.M_E
    var eMinusX = 0.0
    var guesses = 1
    var totalGuesses = 0
    var totalIntegral = 0.0
    var firstTimeThroughLoop = true
    
    @MainActor init(withData data: Bool){
        
        super.init()
        
        insideData = []
        outsideData = []
        
    }


    /// calculate the value of e^-x from 0 to 1
    /// answer should be close to  0.6321
    /// - Calculates the Value of e^-x using Monte Carlo Integration
    ///
    /// - Parameter sender: Any
    func calculateEMinusX() async {
        
        var maxGuesses = 0.0
        let boundingBoxCalculator = BoundingBox() ///Instantiates Class needed to calculate the area of the bounding box.
        
        
        maxGuesses = Double(guesses)
        
        let newValue = await calculateMonteCarloIntegral(e: e, maxGuesses: maxGuesses)
        
        totalIntegral = totalIntegral + newValue
        
        totalGuesses = totalGuesses + guesses
        
        await updateTotalGuessesString(text: "\(totalGuesses)")
        
        //totalGuessesString = "\(totalGuesses)"
        
        ///Calculates the value of π from the area of a unit circle
        
        eMinusX = totalIntegral/Double(totalGuesses) * boundingBoxCalculator.calculateSurfaceArea(numberOfSides: 2, lengthOfSide1: 1.0, lengthOfSide2: 1.0, lengthOfSide3: 0.0)
        
        await updateEMinusXString(text: "\(eMinusX)")
        
     
       
        
    }

    /// calculates the Monte Carlo Integral of e^-x
    ///
   
    func calculateMonteCarloIntegral(e: Double, maxGuesses: Double) async -> Double {
        
        var numberOfGuesses = 0.0
        var pointsInFunction = 0.0
        var integral = 0.0
        var point = (xPoint: 0.0, yPoint: 0.0)
        var ePoint = 0.0
        var actualEMinusX = 0.6321205588285577
        var newInsidePoints : [(xPoint: Double, yPoint: Double)] = []
        var newOutsidePoints : [(xPoint: Double, yPoint: Double)] = []
        
        
        while numberOfGuesses < maxGuesses {
            
            /* Calculate 2 random values within the box */
            /* Determine the distance from that point to the origin */
            /* If the distance is less than the unit radius count the point being within the Unit Circle */
            point.xPoint = Double.random(in: 0.0...1.0)
            point.yPoint = Double.random(in: 0.0...1.0)
            
            ePoint = pow(e, -point.xPoint)
            
            
          
            if((ePoint - point.yPoint) >= 0.0){
                pointsInFunction += 1.0
                
                
                newInsidePoints.append(point)
               
            }
            else { //if outside the circle do not add to the number of points in the radius
                
                
                newOutsidePoints.append(point)

                
            }
            
            numberOfGuesses += 1.0
            
            
            
            
            }

        
        integral = Double(pointsInFunction)
        
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        if ((totalGuesses < 500001) || (firstTimeThroughLoop)){
        
//            insideData.append(contentsOf: newInsidePoints)
//            outsideData.append(contentsOf: newOutsidePoints)
            
            var plotInsidePoints = newInsidePoints
            var plotOutsidePoints = newOutsidePoints
            
            if (newInsidePoints.count > 750001) {
                
                plotInsidePoints.removeSubrange(750001..<newInsidePoints.count)
            }
            
            if (newOutsidePoints.count > 750001){
                plotOutsidePoints.removeSubrange(750001..<newOutsidePoints.count)
                
            }
            
            await updateData(insidePoints: plotInsidePoints, outsidePoints: plotOutsidePoints)
            firstTimeThroughLoop = false
        }
        
        return integral
        }
    
    
    /// updateData
    /// The function runs on the main thread so it can update the GUI
    /// - Parameters:
    ///   - insidePoints: points inside the circle of the given radius
    ///   - outsidePoints: points outside the circle of the given radius
    @MainActor func updateData(insidePoints: [(xPoint: Double, yPoint: Double)] , outsidePoints: [(xPoint: Double, yPoint: Double)]){
        
        insideData.append(contentsOf: insidePoints)
        outsideData.append(contentsOf: outsidePoints)
    }
    
    /// updateTotalGuessesString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the number of total guesses
    @MainActor func updateTotalGuessesString(text:String){
        
        self.totalGuessesString = text
        
    }
    
    /// updatePiString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of Pi
    @MainActor func updateEMinusXString(text:String){
        
        self.eMinusXString = text
        
    }
    
    
    /// setButton Enable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        
        
        if state {
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = true
                }
            }
            
            
                
        }
        else{
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = false
                }
            }
                
        }
        
    }

}
