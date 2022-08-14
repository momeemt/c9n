import std/[unittest, strutils]
import c9npkg/rle

func `&` (n: uint8): char = char(n)
proc decodedLog (raw: string, decoded: openArray[char]) =
  echo raw.len, "bytes => ", decoded.len, "bytes"

suite "naive run-length":
  test "basic encode":
    let
      raw = "aabcccdddd"
      decoded = ['a', &2, 'b', &1, 'c', &3, 'd', &4]
    check encodeNaiveRLE(raw, 0xff) == decoded
    decodedLog(raw, decoded)

  test "when exceeding the limit":
    let
      raw = repeat('a', 300)
      decoded = ['a', &255, 'a', &45]
    check encodeNaiveRLE(raw, 0xff) == decoded
    decodedLog(raw, decoded)
  
  test "decode":
    check decodeNativeRLE(['a', &2, 'b', &1, 'c', &3, 'd', &4]) == "aabcccdddd"
    check decodeNativeRLE(['a', &255, 'a', &45]) == repeat('a', 300)

suite "flag run-length":
  test "basic encode":
    let
      raw = "aabcccdddd"
      decoded = [&0xff, 'a', &2, 'b', &0xff, 'c', &3, &0xff, 'd', &4]
    check encodeFlagRLE(raw, &0xff) == decoded
    decodedLog(raw, decoded)
  
  test "encode text includes flag":
    let
      raw = "abb"
      decoded = [&97, 'a', &1, &97, 'b', &2]
    check encodeFlagRLE(raw, &97) == decoded
    decodedLog(raw, decoded)
  
  test "decode":
    check decodeFlagRLE([&0xff, 'a', &2, 'b', &0xff, 'c', &3], &0xff) == "aabccc"
    check decodeFlagRLE([&97, 'a', &1, &97, 'b', &2], &97) == "abb"
