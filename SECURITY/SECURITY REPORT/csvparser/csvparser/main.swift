//
//  main.swift
//  csvparser
//
//  Created by Arun Patwardhan on 18/01/20.
//  Copyright © 2020 Amaranthine. All rights reserved.
//

import Foundation

//MARK: - Variables
var fileToParse         : String                        = ""
var delimiter           : String                        = ""
var lines               : [String]                      = [String]()
var parsedResult        : [Dictionary<String, String>]  = [Dictionary<String,String>]()
var keys                : [String]                      = [String]()
var keyFile             : String                        = ""
var plistFile           : String                        = ""
var captureFileName     : Bool                          = false
var captureDelimiter    : Bool                          = false
var captureKeyList      : Bool                          = false
var capturePlist        : Bool                          = false

//MARK: - Argument Processing
//Make sure that the arguments are passed in
if CommandLine.arguments.count == 0
{
    print("Please provide arguments in the following sequence")
    print("csvparser --file <FILENAME> --delimiter <DELIMITER> --keylist <KEYLIST> --plist <PLISTFILE>")
    print("FOR EXAMPLE:")
    print("csvparser --file ~/Desktop/input.csv --delimiter , --keylist keys.txt -- plist com.company.name.plist")
}

//Populate the variables based on the data from the arguments
for argument in CommandLine.arguments
{
    if captureFileName
    {
        fileToParse = argument
        captureFileName = false
    }
    if captureDelimiter
    {
        delimiter = argument
        captureDelimiter = false
    }
    if captureKeyList
    {
        keyFile = argument
        captureKeyList = false
    }
    if capturePlist
    {
        plistFile = argument
        capturePlist = false
    }
    
    switch argument {
        case "--file":
        captureFileName = true
        case "--delimiter":
        captureDelimiter = true
        case "--keylist":
            captureKeyList = true
        case "--plist":
            capturePlist = true
        default:
        continue
    }
}

//MARK: - Parsing
//Split the document into an array of lines
lines = splitIntoLines(contentsOf: fileToParse)
keys = splitIntoLines(contentsOf: keyFile)

//Clean out the array
let cleanLines = lines.filter({(input : String) -> Bool in
    return !input.isEmpty
})

//Parse out the line and populate into the dictionary
for line in cleanLines
{
    let lineParts                                       = line.components(separatedBy: delimiter)
    
    var tempDictionary  : Dictionary<String,String>     = Dictionary<String,String>()
    var partCount       : Int                           = 0
    for item in lineParts
    {
        var newStr : String = ""
        if item.contains("\"")
        {
            for element in item
            {
                if element != "\""
                {
                    newStr.append(element)
                }
            }
        }
        else
        {
            newStr = item
        }
        
        tempDictionary["\(keys[partCount])"] = newStr
        partCount += 1
    }
    parsedResult.append(tempDictionary)
}

//MARK: - Writing to plist
var dict        : NSMutableDictionary   = NSMutableDictionary(contentsOfFile: plistFile)!
var entryCount  : Int                   = 0

dict.setValue(parsedResult, forKey: "Kext List")
dict.write(toFile: plistFile, atomically: false)
