
import deques
import math
# import strformat

import ./dual_balanced_ternary/types
import ./dual_balanced_ternary/digit
import ./dual_balanced_ternary/float

export DualBalancedTernaryDigit, DualBalancedTernary, addDigits, mutiplyDigits, `$`, parseTernaryDigit, parseTernary, `==`, ternary, toFloat

proc negate*(a: DualBalancedTernary): DualBalancedTernary =
  result = a
  for i in 0..<result.integral.len:
    result.integral[i] = result.integral[i].negate
  for i in 0..<result.fractional.len:
    result.fractional[i] = result.fractional[i].negate

# positive number to make value larger
proc moveBy*(a: DualBalancedTernary, n: int): DualBalancedTernary =
  var b = a
  if n == 0:
    return a
  elif n > 0:
    for i in 0..<n:
      if b.fractional.len == 0:
        b.integral.addFirst dbt5
      else:
        b.integral.addFirst b.fractional.popFirst
  else:
    # n < 0
    for i in 0..<(- n):
      if b.integral.len == 0:
        b.fractional.addFirst dbt5
      else:
        b.fractional.addFirst b.integral.popFirst
  return b

# 0 for unit position, -1 for first fractional position
proc addAt*(a: DualBalancedTernary, idx: int, d: DualBalancedTernaryDigit): DualBalancedTernary =
  # echo "to add: ", a, " ", d, " at: ", idx
  if d == dbt5:
    return a
  var b = a
  if idx >= 0:
    if idx > a.integral.len - 1:
      var times = idx - a.integral.len + 1
      while times > 0:
        b.integral.addLast dbt5
        times = times - 1
      # echo b.integral, " ", idx, " times ", times

      b.integral[idx] = d
      return b
    else:
      let sum = addDigits(a.integral[idx], d)
      b.integral[idx] = sum.unit
      # echo "sum: ", sum
      if sum.carry != dbt5:
        # echo "has carry in integral: ", sum
        return b.addAt(idx + 1, sum.carry)
      else:
        return b
  else:
    let fIdx = -1 - idx
    if fIdx > a.fractional.len - 1:
      var times = fIdx - a.fractional.len + 1
      while times > 0:
        b.fractional.addLast dbt5
        times = times - 1
      b.fractional[fIdx] = d
      return b
    else:
      let sum = addDigits(a.fractional[fIdx], d)
      b.fractional[fIdx] = sum.unit
      if sum.carry != dbt5:
        # echo "has carry in fractional: ", sum
        return b.addAt(idx + 1, sum.carry)
      else:
        return b

proc `+`*(a, b: DualBalancedTernary): DualBalancedTernary =
  var a2 = a
  for idx, item in b.integral:
    # echo "adding: ", a2, " ", idx, " ", item
    a2 = a2.addAt(idx, item)
  for idx, item in b.fractional:
    # echo "f adding: ", a2, " ", idx, " ", item
    a2 = a2.addAt(-1 - idx, item)
  # echo "result: ", a2
  a2.stripEmptyTails()

proc `-`*(a, b: DualBalancedTernary): DualBalancedTernary =
  a + b.negate

proc `*`*(a, b: DualBalancedTernary): DualBalancedTernary =
  for aIdx, aItem in a:
    for bIdx, bItem in b:
      # echo fmt"adding {aIdx} {aItem} {bIdx} {bItem}"
      let v = mutiplyDigits(aItem, bItem)
      result = result.addAt(aIdx + bIdx, v.unit)
      if v.carry != dbt5:
        result = result.addAt(aIdx + bIdx + 1, v.carry)

proc createDualBalancedTernary*(x: float): DualBalancedTernary =
  let negativeValue = x < 0

  var integralPart = x.floor
  var fractionalPart = x - x.floor
  if negativeValue:
    integralPart = 0 - integralPart

  var idx = 0

  while integralPart > 0:
    let left = integralPart.mod 3
    if left == 0:
      discard
    elif left == 1:
      result = result.addAt(idx, dbt3)
    elif left == 2:
      result = result.addAt(idx + 1, dbt3)
      result = result.addAt(idx, dbt7)
    else:
      raise newException(ValueError, "unexpected reminder: " & $left & " from " & $x)
    integralPart = (integralPart - left) / 3
    idx = idx + 1

  if negativeValue:
    for idx, item in result.integral:
      result.integral[idx] = item.negate()

  var fIdx = -1
  var precision = devisionPrecision # TODO
  while fractionalPart > 0 and precision >= 0:
    fractionalPart = fractionalPart * 3
    let left = fractionalPart.floor
    if left == 0:
      discard
    elif left == 1:
      result = result.addAt(fIdx, dbt3)
    elif left == 2:
      result = result.addAt(fIdx + 1, dbt3)
      result = result.addAt(fIdx, dbt7)
    else:
      raise newException(ValueError, "unexpected carry: " & $left & " from " & $fractionalPart)
    fractionalPart = fractionalPart - left
    fIdx = fIdx - 1
    precision = precision - 1

proc createDualBalancedTernary*(x, y: float): DualBalancedTernary =
  let a = x.createDualBalancedTernary()
  var b = y.createDualBalancedTernary()
  for idx, item in b.integral:
    b.integral[idx] = item.flipXy
  for idx, item in b.fractional:
    b.fractional[idx] = item.flipXy
  return a + b
