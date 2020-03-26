//
//  FileParser.swift
//  csvparser
//
//  Created by Arun Patwardhan on 18/01/20.
//  Copyright © 2020 Amaranthine. All rights reserved.
//

import Foundation

//Read the contents of the file and split it into lines.
func splitIntoLines(contentsOf fileName : String) -> [String]
{
    do
    {
        let data = try String(contentsOfFile: fileName, encoding: .ascii)
        let myStrings = data.components(separatedBy: .newlines)
        return myStrings
    }
    catch {
        return []
    }
}
