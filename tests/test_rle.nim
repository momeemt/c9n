import std/[unittest, strutils]
import c9npkg/rle

suite "naive run-length":
  test "basic encode":
    check encodeNaiveRLE("aabcccdddd", 0xff) == ['a', char(2), 'b', char(1), 'c', char(3), 'd', char(4)]

  test "when exceeding the limit":
    let data = repeat('a', 300)
    check encodeNaiveRLE(data, 0xff) == ['a', char(255), 'a', char(45)]
  
  test "decode":
    check decodeNativeRLE(['a', char(2), 'b', char(1), 'c', char(3), 'd', char(4)]) == "aabcccdddd"
    check decodeNativeRLE(['a', char(255), 'a', char(45)]) == repeat('a', 300)
