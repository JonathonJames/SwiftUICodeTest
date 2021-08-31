//
//  TaskTests.swift
//  everyLIFE_TechTestTests
//
//  Created by Jonathon James on 31/08/2021.
//

import XCTest
@testable import everyLIFE_TechTest


/// A class which encapsulates the unit tests for the `Task` type.
final class TaskTests: XCTestCase {
    
    /// Test that the raw values of the category/types of tasks matches the expected value.
    /// - Throws: An error if any of the test scenarios fail.
    ///
    /// Scenario 1:-
    ///   GIVEN that we have a `Category` value of case `general`
    ///   AND we examine that value's `rawValue`
    ///   THEN the rawValue should be equal to "general".
    /// Scenario 2:-
    ///   GIVEN that we have a `Category` value of case `hydration`
    ///   AND we examine that value's `rawValue`
    ///   THEN the rawValue should be equal to "hydration".
    /// Scenario 3:-
    ///   GIVEN that we have a `Category` value of case `medication`
    ///   AND we examine that value's `rawValue`
    ///   THEN the rawValue should be equal to "medication".
    /// Scenario 4:-
    ///   GIVEN that we have a `Category` value of case `nutrition`
    ///   AND we examine that value's `rawValue`
    ///   THEN the rawValue should be equal to "nutrition".
    func testCategoryRawValues() throws {
        XCTAssertEqual(Task.Category.general.rawValue, "general", "Unexpected category raw value")
        XCTAssertEqual(Task.Category.hydration.rawValue, "hydration", "Unexpected category raw value")
        XCTAssertEqual(Task.Category.medication.rawValue, "medication", "Unexpected category raw value")
        XCTAssertEqual(Task.Category.nutrition.rawValue, "nutrition", "Unexpected category raw value")
    }
    
    /// Tests that initializing a `Category` with a raw value results in the expect value.
    /// - Throws: An error if any of the test scenarios fail.
    ///
    /// Scenario 1:-
    ///   GIVEN that we initialize a `Category` value with a string of "general",
    ///   THEN the resulting value should be equal to a case of `.general`.
    /// Scenario 2:-
    ///   GIVEN that we initialize a `Category` value with a string of "hydration",
    ///   THEN the resulting value should be equal to a case of `.hydration`.
    /// Scenario 3:-
    ///   GIVEN that we initialize a `Category` value with a string of "medication",
    ///   THEN the resulting value should be equal to a case of `.medication`.
    /// Scenario 4:-
    ///   GIVEN that we initialize a `Category` value with a string of "nutrition",
    ///   THEN the resulting value should be equal to a case of `.nutrition`.
    /// Scenario 5:-
    ///   GIVEN that we initialize a `Category` value with a string of anything not equal to "general", "hydration", "medication", or "nutrition",
    ///   THEN the resulting value should be equal to `nil`.
    func testCategoryInitFromRawValue() throws {
        
        XCTAssertEqual(Task.Category(rawValue: "general"), .general, "Category mismatch")
        XCTAssertEqual(Task.Category(rawValue: "hydration"), .hydration, "Category mismatch")
        XCTAssertEqual(Task.Category(rawValue: "medication"), .medication, "Category mismatch")
        XCTAssertEqual(Task.Category(rawValue: "nutrition"), .nutrition, "Category mismatch")
        XCTAssertNil(Task.Category(rawValue: "other"), "Category mismatch")
        XCTAssertNil(Task.Category(rawValue: ""), "Category mismatch")
    }
    
    /// Tests that initializing a `Task` using the example data from https://adam-deleteme.s3.amazonaws.com/tasks.json (on 31/08/2021) suceeds.
    /// - Throws: An error if any of the test scenarios fail.
    ///
    /// Scenario 1:-
    ///   GIVEN that we have JSON data which represents an array of `Task`s
    ///   AND we use a JSONDecoder to decode these values
    ///   THEN no error should be thrown
    ///   AND an array of `Task`s matching the data will have been initialized.
    func testInitFromDecoder_success() throws {
        
        let json: Data = """
            [
              {
                "id": 1,
                "name": "Take the rubbish out",
                "description": "Empty the bin and take the rubbish and recycling to the communal rubbish bins that are on the lower ground floor of the building",
                "type": "general"
              },
              {
                "id": 2,
                "name": "Make a hot drink",
                "description": "Make David a cup of tea with full fat milk  and no sugar.  David likes to have his tea medium strength",
                "type": "hydration"
              },
              {
                "id": 3,
                "name": "5 ml Azopt 10mg/1ml",
                "description": "Instil one drop to both eyes at the morning. Put on by HM checked by VH. This is now only to be put in in the morning as the private carer will instil at lunch time",
                "type": "medication"
              },
              {
                "id": 4,
                "name": "Asprin",
                "description": "This is dispersible and should be dissolved in water and administered with or just after food.",
                "type": "medication"
              },
              {
                "id": 5,
                "name": "Make a snack",
                "description": "Soup, or biscuits or both. David also likes Advocate with salt on.  Request from David's son not to make any other food as David is not eating it and it is then left out overnight and attracting mice.",
                "type": "nutrition"
              },
              {
                "id": 6,
                "name": "Eyelid hygiene",
                "description": "The eyelids should be washed with a cotton bud dipped into a mixture of 1 part baby shampoo and 4 parts water. Linda is going to ensure that the cotton buds and baby shampoo are available. The care worker should wipe the outside of the eyelids with the cotton bud.",
                "type": "general"
              }
            ]
        """.data(using: .utf8)!
        
        // In this specific instance the decoding is not custom, so for now we're only really testing native functionality. However this
        // could change in the future, so it's still important to test succesful decoding is working as expected.
        
        let decoder: JSONDecoder = .init()
        var output: [Task]!
        
        XCTAssertNoThrow(output = try decoder.decode([Task].self, from: json), "Decoding the tasks should not throw an error")
        XCTAssertEqual(output.count, 6, "There should have been 6 tasks that have been decoded")
        
        output.enumerated().forEach { index, task in
            
            XCTAssertEqual(Int64(index + 1), task.id, "With this dataset, the task id should be +1 of the index.")
            
            switch index {
            case 0:
                XCTAssertEqual("Take the rubbish out", task.name, "Unexpected name")
                XCTAssertEqual(
                    "Empty the bin and take the rubbish and recycling to the communal rubbish bins that are on the lower ground floor of the building",
                    task.description,
                    "Unexpected description"
                )
                XCTAssertEqual(.general, task.type, "Unexpected type")
            case 1:
                XCTAssertEqual("Make a hot drink", task.name, "Unexpected name")
                XCTAssertEqual(
                    "Make David a cup of tea with full fat milk  and no sugar.  David likes to have his tea medium strength",
                    task.description,
                    "Unexpected description"
                )
                XCTAssertEqual(.hydration, task.type, "Unexpected type")
            case 2:
                XCTAssertEqual("5 ml Azopt 10mg/1ml", task.name, "Unexpected name")
                XCTAssertEqual(
                    "Instil one drop to both eyes at the morning. Put on by HM checked by VH. This is now only to be put in in the morning as the private carer will instil at lunch time",
                    task.description,
                    "Unexpected description"
                )
                XCTAssertEqual(.medication, task.type, "Unexpected type")
            case 3:
                XCTAssertEqual("Asprin", task.name, "Unexpected name")
                XCTAssertEqual(
                    "This is dispersible and should be dissolved in water and administered with or just after food.",
                    task.description,
                    "Unexpected description"
                )
                XCTAssertEqual(.medication, task.type, "Unexpected type")
            case 4:
                XCTAssertEqual("Make a snack", task.name, "Unexpected name")
                XCTAssertEqual(
                    "Soup, or biscuits or both. David also likes Advocate with salt on.  Request from David's son not to make any other food as David is not eating it and it is then left out overnight and attracting mice.",
                    task.description,
                    "Unexpected description"
                )
                XCTAssertEqual(.nutrition, task.type, "Unexpected type")
            case 5:
                XCTAssertEqual("Eyelid hygiene", task.name, "Unexpected name")
                XCTAssertEqual(
                    "The eyelids should be washed with a cotton bud dipped into a mixture of 1 part baby shampoo and 4 parts water. Linda is going to ensure that the cotton buds and baby shampoo are available. The care worker should wipe the outside of the eyelids with the cotton bud.",
                    task.description,
                    "Unexpected description"
                )
                XCTAssertEqual(.general, task.type, "Unexpected type")
            default:
                XCTFail("Unexpect index")
            }
        }
    }

    /// Tests that initializing a `Task` using invalid data correctly throws an error.
    /// - Throws: An error if the test scenario fails.
    ///
    /// Scenario 1:-
    ///   GIVEN that we have JSON data which almost represents a `Task`, but incorrectly has the `id` field as a String
    ///   AND we use a JSONDecoder to decode a `Task` from this data
    ///   THEN a decoding error should be thrown
    ///   AND that error will denote the type mismatch on the "id" field.
    func testInitFromDecoder_failure() throws {
        
        // In this specific instance the decoding is not custom, so we know that it's only going to fail in a native, standard fashion.
        // However, that could change in the future, so it's still worthwhile checking that the failures occur when and where we expect
        // them to.
        
        let json: Data = """
          {
            "id": "1",
            "name": "Take the rubbish out",
            "description": "Empty the bin and take the rubbish and recycling to the communal rubbish bins that are on the lower ground floor of the building",
            "type": "general"
          }
        """.data(using: .utf8)!
        let decoder: JSONDecoder = .init()
        var output: Task!
        
        XCTAssertThrowsError(output = try decoder.decode(Task.self, from: json), "", { error in
            guard case .typeMismatch(let type, let context) = error as? DecodingError,
                  type == Int64.self,
                  context.debugDescription == "Expected to decode Int64 but found a string/data instead.",
                  context.codingPath.count == 1,
                  context.codingPath[0].intValue == nil,
                  context.codingPath[0].stringValue == "id" else {
                XCTFail("Unexpected error type.")
                return
            }
        })
        XCTAssertNil(output, "Output should be nil since decoding failed.")
    }
}
