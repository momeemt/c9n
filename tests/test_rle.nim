import std/[unittest, strutils]
import c9npkg/rle

func `&` (n: uint8): char = char(n)
proc decodedLog (raw: string, decoded: openArray[char]) =
  echo raw.len, "bytes => ", decoded.len, "bytes"

suite "naive run-length":
  test "basic encode":
    let
      raw = "aabcccdddd"
      decoded = [&2, 'a', &1, 'b', &3, 'c', &4, 'd']
    check encodeNaiveRLE(raw, 0xff) == decoded
    decodedLog(raw, decoded)

  test "when exceeding the limit":
    let
      raw = repeat('a', 300)
      decoded = [&255, 'a', &45, 'a']
    check encodeNaiveRLE(raw, 0xff) == decoded
    decodedLog(raw, decoded)
  
  test "decode":
    check decodeNativeRLE([&2, 'a', &1, 'b', &3, 'c', &4, 'd']) == "aabcccdddd"
    check decodeNativeRLE([&255, 'a', &45, 'a']) == repeat('a', 300)

suite "flag run-length":
  test "basic encode":
    let
      raw = "aabcccdddd"
      decoded = [&0xff, &2, 'a', 'b', &0xff, &3, 'c', &0xff, &4, 'd']
    check encodeFlagRLE(raw, &0xff) == decoded
    decodedLog(raw, decoded)
  
  test "encode text includes flag":
    let
      raw = "abb"
      decoded = [&97, &1, 'a', &97, &2, 'b']
    check encodeFlagRLE(raw, &97) == decoded
    decodedLog(raw, decoded)
  
  test "decode":
    check decodeFlagRLE([&0xff, &2, 'a', 'b', &0xff, &3, 'c'], &0xff) == "aabccc"
    check decodeFlagRLE([&97, &1, 'a', &97, &2, 'b'], &97) == "abb"
