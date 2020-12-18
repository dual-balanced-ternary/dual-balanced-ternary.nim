
import ./types

type DigitsPair* = tuple[carry: DualBalancedTernaryDigit, unit: DualBalancedTernaryDigit]

proc negate*(a: DualBalancedTernaryDigit): DualBalancedTernaryDigit =
  case a
    of dbt1: dbt9
    of dbt2: dbt8
    of dbt3: dbt7
    of dbt4: dbt6
    of dbt5: dbt5
    of dbt6: dbt4
    of dbt7: dbt3
    of dbt8: dbt2
    of dbt9: dbt1

proc flipFrontBack*(a: DualBalancedTernaryDigit): DualBalancedTernaryDigit =
  case a
    of dbt1: dbt9
    of dbt2: dbt6
    of dbt3: dbt7
    of dbt4: dbt8
    of dbt5: dbt5
    of dbt6: dbt2
    of dbt7: dbt7
    of dbt8: dbt4
    of dbt9: dbt1

proc flipLeftRight*(a: DualBalancedTernaryDigit): DualBalancedTernaryDigit =
  case a
    of dbt1: dbt1
    of dbt2: dbt4
    of dbt3: dbt7
    of dbt4: dbt2
    of dbt5: dbt5
    of dbt6: dbt8
    of dbt7: dbt3
    of dbt8: dbt6
    of dbt9: dbt9

proc rotate3*(a: DualBalancedTernaryDigit): DualBalancedTernaryDigit =
  case a
    of dbt1: dbt3
    of dbt2: dbt6
    of dbt3: dbt9
    of dbt4: dbt2
    of dbt5: dbt5
    of dbt6: dbt8
    of dbt7: dbt1
    of dbt8: dbt4
    of dbt9: dbt7

proc rotate7*(a: DualBalancedTernaryDigit): DualBalancedTernaryDigit =
  case a
    of dbt1: dbt7
    of dbt2: dbt4
    of dbt3: dbt1
    of dbt4: dbt8
    of dbt5: dbt5
    of dbt6: dbt2
    of dbt7: dbt9
    of dbt8: dbt6
    of dbt9: dbt3

# x: 3->1 , y: 1->3
proc flipXy*(a: DualBalancedTernaryDigit): DualBalancedTernaryDigit =
  case a
    of dbt1: dbt3
    of dbt2: dbt2
    of dbt3: dbt1
    of dbt4: dbt6
    of dbt5: dbt5
    of dbt6: dbt4
    of dbt7: dbt9
    of dbt8: dbt8
    of dbt9: dbt7

proc addDigits*(a, b: DualBalancedTernaryDigit): DigitsPair =
  case a
    of dbt1:
      case b
        of dbt1: (dbt1, dbt9)
        of dbt2: (dbt5, dbt7)
        of dbt3: (dbt5, dbt8)
        of dbt4: (dbt5, dbt3)
        of dbt5: (dbt5, dbt1)
        of dbt6: (dbt1, dbt2)
        of dbt7: (dbt5, dbt6)
        of dbt8: (dbt1, dbt4)
        of dbt9: (dbt5, dbt5)
    of dbt2:
      case b
        of dbt1: (dbt5, dbt7)
        of dbt2: (dbt2, dbt8)
        of dbt3: (dbt5, dbt9)
        of dbt4: (dbt9, dbt1)
        of dbt5: (dbt5, dbt2)
        of dbt6: (dbt7, dbt3)
        of dbt7: (dbt7, dbt4)
        of dbt8: (dbt5, dbt5)
        of dbt9: (dbt9, dbt6)
    of dbt3:
      case b
        of dbt1: (dbt5, dbt8)
        of dbt2: (dbt5, dbt9)
        of dbt3: (dbt3, dbt7)
        of dbt4: (dbt3, dbt2)
        of dbt5: (dbt5, dbt3)
        of dbt6: (dbt5, dbt1)
        of dbt7: (dbt5, dbt5)
        of dbt8: (dbt3, dbt6)
        of dbt9: (dbt5, dbt4)
    of dbt4:
      case b
        of dbt1: (dbt5, dbt3)
        of dbt2: (dbt9, dbt1)
        of dbt3: (dbt3, dbt2)
        of dbt4: (dbt4, dbt6)
        of dbt5: (dbt5, dbt4)
        of dbt6: (dbt5, dbt5)
        of dbt7: (dbt5, dbt9)
        of dbt8: (dbt3, dbt7)
        of dbt9: (dbt9, dbt8)
    of dbt5:
      (dbt5, b)
    of dbt6:
      case b
        of dbt1: (dbt1, dbt2)
        of dbt2: (dbt7, dbt3)
        of dbt3: (dbt5, dbt1)
        of dbt4: (dbt5, dbt5)
        of dbt5: (dbt5, dbt6)
        of dbt6: (dbt6, dbt4)
        of dbt7: (dbt7, dbt8)
        of dbt8: (dbt1, dbt9)
        of dbt9: (dbt5, dbt7)
    of dbt7:
      case b
        of dbt1: (dbt5, dbt6)
        of dbt2: (dbt7, dbt4)
        of dbt3: (dbt5, dbt5)
        of dbt4: (dbt5, dbt9)
        of dbt5: (dbt5, dbt7)
        of dbt6: (dbt7, dbt8)
        of dbt7: (dbt7, dbt3)
        of dbt8: (dbt5, dbt1)
        of dbt9: (dbt5, dbt2)
    of dbt8:
      case b
        of dbt1: (dbt1, dbt4)
        of dbt2: (dbt5, dbt5)
        of dbt3: (dbt3, dbt6)
        of dbt4: (dbt3, dbt7)
        of dbt5: (dbt5, dbt8)
        of dbt6: (dbt1, dbt9)
        of dbt7: (dbt5, dbt1)
        of dbt8: (dbt8, dbt2)
        of dbt9: (dbt5, dbt3)
    of dbt9:
      case b
        of dbt1: (dbt5, dbt5)
        of dbt2: (dbt9, dbt6)
        of dbt3: (dbt5, dbt4)
        of dbt4: (dbt9, dbt8)
        of dbt5: (dbt5, dbt9)
        of dbt6: (dbt5, dbt7)
        of dbt7: (dbt5, dbt2)
        of dbt8: (dbt5, dbt3)
        of dbt9: (dbt9, dbt1)

proc mutiplyDigits*(a, b: DualBalancedTernaryDigit): DigitsPair =
  case a
    of dbt1:
      (dbt5, b)
    of dbt2:
      case b
        of dbt1: (dbt5, dbt2)
        of dbt2: (dbt3, dbt7)
        of dbt3: (dbt5, dbt6)
        of dbt4: (dbt1, dbt9)
        of dbt5: (dbt5, dbt5)
        of dbt6: (dbt9, dbt1)
        of dbt7: (dbt5, dbt4)
        of dbt8: (dbt7, dbt3)
        of dbt9: (dbt5, dbt8)
    of dbt3:
      (dbt5, b.rotate3())
    of dbt4:
      case b
        of dbt1: (dbt5, dbt4)
        of dbt2: (dbt1, dbt9)
        of dbt3: (dbt5, dbt2)
        of dbt4: (dbt7, dbt3)
        of dbt5: (dbt5, dbt5)
        of dbt6: (dbt3, dbt7)
        of dbt7: (dbt5, dbt8)
        of dbt8: (dbt9, dbt1)
        of dbt9: (dbt5, dbt6)
    of dbt5:
      (dbt5, dbt5)
    of dbt6:
      case b
        of dbt1: (dbt5, dbt6)
        of dbt2: (dbt9, dbt1)
        of dbt3: (dbt5, dbt8)
        of dbt4: (dbt3, dbt7)
        of dbt5: (dbt5, dbt5)
        of dbt6: (dbt7, dbt3)
        of dbt7: (dbt5, dbt2)
        of dbt8: (dbt1, dbt9)
        of dbt9: (dbt5, dbt4)
    of dbt7:
      (dbt5, b.rotate7())
    of dbt8:
      case b
        of dbt1: (dbt1, dbt8)
        of dbt2: (dbt7, dbt3)
        of dbt3: (dbt5, dbt4)
        of dbt4: (dbt9, dbt1)
        of dbt5: (dbt5, dbt5)
        of dbt6: (dbt1, dbt9)
        of dbt7: (dbt5, dbt6)
        of dbt8: (dbt3, dbt7)
        of dbt9: (dbt5, dbt2)
    of dbt9:
      (dbt5, b.negate)

proc splitYx*(a: DualBalancedTernaryDigit): tuple[y: DualBalancedTernaryDigit, x: DualBalancedTernaryDigit] =
  case a
    of dbt1: (dbt1, dbt5)
    of dbt2: (dbt9, dbt7)
    of dbt3: (dbt5, dbt3)
    of dbt4: (dbt9, dbt3)
    of dbt5: (dbt5, dbt5)
    of dbt6: (dbt1, dbt7)
    of dbt7: (dbt5, dbt7)
    of dbt8: (dbt1, dbt3)
    of dbt9: (dbt9, dbt5)
