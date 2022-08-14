## Run Length Encoding

import std/strutils

func encodeNaiveRLE* (data: string, limit: int): string =
  var counter = 1
  for index in 1..data.len:
    if index < data.len and data[index-1] == data[index] and counter < limit:
      counter += 1
    else:
      result.add data[index-1]
      result.add char(counter)
      counter = 1

func decodeNativeRLE* (data: openArray[char]): string =
  for index in 0 ..< data.len div 2:
    result.add repeat(data[index*2], int(data[index*2+1]))

func encodeFlagRLE* (data: string, flag: char): string =
  var counter = 1
  for index in 1..data.len:
    if index < data.len and data[index-1] == data[index] and counter < 0xff:
      counter += 1
    elif counter == 1 and data[index-1] != flag:
      result.add data[index-1]
    else:
      result.add flag
      result.add data[index-1]
      result.add char(counter)
      counter = 1

func decodeFlagRLE* (data: openArray[char], flag: char): string =
  var index = 0
  while index < data.len:
    if data[index] == flag:
      result.add repeat(data[index+1], int(data[index+2]))
      index += 2
    else:
      result.add data[index]
    index += 1