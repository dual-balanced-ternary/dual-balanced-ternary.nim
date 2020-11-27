
import deques
import strutils

# places of digits
#
#   6 1 8
#   7 5 3
#   2 9 4

# how many digits in fractional part, when it's not divisible
var devisionPrecision = 10

type DualBalancedTernaryDigit* = enum
  dbt1, dbt2, dbt3, dbt4, dbt5, dbt6, dbt7, dbt8, dbt9

type DualBalancedTernary* = object
  # digits near 0 are placed first
  integral*: Deque[DualBalancedTernaryDigit]
  fractional*: Deque[DualBalancedTernaryDigit]

proc `$`*(d: DualBalancedTernaryDigit): string =
  case d
    of dbt1: "1"
    of dbt2: "2"
    of dbt3: "3"
    of dbt4: "4"
    of dbt5: "5"
    of dbt6: "6"
    of dbt7: "7"
    of dbt8: "8"
    of dbt9: "9"

proc `$`*(x: DualBalancedTernary): string =
  result = "&"
  for i in 0..<x.integral.len:
    result = result & $x.integral[x.integral.len - i - 1]
  result = result & "."
  for i in 0..<x.fractional.len:
    result = result & $x.fractional[i]

proc parseTernaryDigit*(s: string): DualBalancedTernaryDigit =
  case s
    of "1": dbt1
    of "2": dbt2
    of "3": dbt3
    of "4": dbt4
    of "5": dbt5
    of "6": dbt6
    of "7": dbt7
    of "8": dbt8
    of "9": dbt9
    else:
      raise newException(ValueError, s & " is not valid ternary digit representation")

# 5 is the zero point of digits, can be removed at end
proc stripEmptyTails(x: DualBalancedTernary): DualBalancedTernary =
  if (x.integral.len == 0 or x.integral[^1] != dbt5) and
    (x.fractional.len == 0 or x.fractional[^1] != dbt5):
    return x
  var y = x
  while y.integral.len > 0 and y.integral[^1] == dbt5:
    y.integral.popLast()
  while y.fractional.len > 0 and y.fractional[^1] == dbt5:
    y.fractional.popLast()
  return y

proc parseTernaryDigit*(s: char): DualBalancedTernaryDigit =
  case s
    of '1': dbt1
    of '2': dbt2
    of '3': dbt3
    of '4': dbt4
    of '5': dbt5
    of '6': dbt6
    of '7': dbt7
    of '8': dbt8
    of '9': dbt9
    else:
      raise newException(ValueError, s & " is not valid ternary digit representation")

proc parseTernary*(s: string): DualBalancedTernary =
  if s.len == 0:
    raise newException(ValueError, "ternary requires & symbol")
  let content = s[1..^1]
  if content.len == 0:
    raise newException(ValueError, "ternary requires a number, at least &5")
  let pieces = content.split(".")
  if pieces.len >= 1:
    let chunk = pieces[0]
    for c in chunk:
      result.integral.addFirst c.parseTernaryDigit
  if pieces.len == 2:
    let chunk = pieces[1]
    for c in chunk:
      result.fractional.addLast c.parseTernaryDigit
  if pieces.len > 2:
    raise newException(ValueError, "invalid format for a ternary value: " & s)
  result = result.stripEmptyTails
