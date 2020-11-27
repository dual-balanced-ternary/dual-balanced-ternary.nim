
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
  integral*: seq[DualBalancedTernaryDigit]
  fractional*: seq[DualBalancedTernaryDigit]

proc digitToStr*(d: DualBalancedTernaryDigit): string =
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

proc strToDigit*(s: string): DualBalancedTernaryDigit =
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
