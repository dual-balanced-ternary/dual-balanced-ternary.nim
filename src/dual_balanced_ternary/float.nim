
import math
import deques

import ./types
import ./digit

type ComplextXy* = tuple
  x: float
  y: float

let fractionalBase = 1 / 3

proc flipXy*(p: ComplextXy): ComplextXy =
  (p.y, p.x)

# 1 points at y direction, 3 points at x direction
proc toFloat(a: DualBalancedTernaryDigit): ComplextXy =
  case a
    of dbt1: (0.0, 1.0)
    of dbt2: (-1.0, -1.0)
    of dbt3: (1.0, 0.0)
    of dbt4: (1.0, -1.0)
    of dbt5: (0.0, 0.0)
    of dbt6: (-1.0, 1.0)
    of dbt7: (-1.0, 0.0)
    of dbt8: (1.0, 1.0)
    of dbt9: (0.0, -1.0)

proc toDigit(x, y: int): DualBalancedTernaryDigit =
  case x
  of -1:
    case y
      of -1: return dbt2
      of 0: return dbt7
      of 1: return dbt6
      else:
        raise newException(ValueError, "unexpected y: " & $y)
  of 0:
    case y
      of -1: return dbt9
      of 0: return dbt5
      of 1: return dbt1
      else:
        raise newException(ValueError, "unexpected y: " & $y)
  of 1:
    case y
      of -1: return dbt8
      of 0: return dbt3
      of 1: return dbt4
      else:
        raise newException(ValueError, "unexpected y: " & $y)
  else:
    raise newException(ValueError, "unexpected x: " & $x)

proc toFloat*(a: DualBalancedTernary): ComplextXy =
  var unit = 1.0
  for idx, item in a.integral:
    let v = item.toFloat()
    result.x = result.x + v.x * unit
    result.y = result.y + v.y * unit
    unit = unit * 3
  unit = 1.0
  for idx, item in a.fractional:
    unit = unit / 3
    let v = item.toFloat()
    result.x = result.x + v.x * unit
    result.y = result.y + v.y * unit
