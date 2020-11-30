
import deques
import math
import strformat

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

# TODO positive number to make value larger, not in use yet
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
      let v = mutiplyDigits(aItem, bItem)
      result = result.addAt(aIdx + bIdx, v.unit)
      if v.carry != dbt5:
        result = result.addAt(aIdx + bIdx + 1, v.carry)
      # echo fmt"multiply a:{aItem} b:{bItem}, v:{v}, result:{result}"

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

# keep value of 1 direction and flip 3 direction
proc conjugate*(a: DualBalancedTernary): DualBalancedTernary =
  result = a
  for idx, item in result.integral:
    result.integral[idx] = item.flipLeftRight
  for idx, item in result.fractional:
    result.fractional[idx] = item.flipLeftRight

# value at y direction only contains 1, 5, 9,
# value at x direction only contains 7, 5, 3.
proc splitYx*(a: DualBalancedTernary): tuple[y: DualBalancedTernary, x: DualBalancedTernary] =
  var x: DualBalancedTernary = a
  var y: DualBalancedTernary = a
  for idx, item in a.integral:
    let v = item.splitYx
    x.integral[idx] = v.x
    y.integral[idx] = v.y
  for idx, item in a.fractional:
    let v = item.splitYx
    x.fractional[idx] = v.x
    y.fractional[idx] = v.y
  return (y.stripEmptyTails, x.stripEmptyTails)

proc rotate3(a: DualBalancedTernary): DualBalancedTernary =
  result = a
  for idx, item in result.integral:
    result.integral[idx] = item.rotate3
  for idx, item in result.fractional:
    result.fractional[idx] = item.rotate3

proc rotate7(a: DualBalancedTernary): DualBalancedTernary =
  result = a
  for idx, item in result.integral:
    result.integral[idx] = item.rotate7
  for idx, item in result.fractional:
    result.fractional[idx] = item.rotate7

proc getFirstDigit(a: DualBalancedTernary): tuple[digit: DualBalancedTernaryDigit, idx: int] =
  let a2 = a.stripEmptyTails()
  if a2.integral.len > 0:
    return (a2.integral.peekLast(), a2.integral.len - 1)
  elif a2.fractional.len == 0:
    return (dbt5, 0)
  else:
    for idx, item in a2.fractional:
      if item != dbt5:
        return (item, -1 - idx)

let zero = DualBalancedTernary(
  integral: initDeque[DualBalancedTernaryDigit](),
  fractional: initDeque[DualBalancedTernaryDigit]()
)

# only works for paths containing 1,5,9
proc `>`*(a, b: DualBalancedTernary): bool =
  let delta = a - b
  let head = delta.getFirstDigit
  head.digit == dbt1

# only works for paths containing 1,5,9
proc `<`*(a, b: DualBalancedTernary): bool =
  let delta = a - b
  let head = delta.getFirstDigit
  head.digit == dbt9

# ternary divide only handles values consisted of 1,5,9
proc ternaryDivide(a, b: DualBalancedTernary): DualBalancedTernary =
  # echo fmt"dividing: a b {a} {b}"
  if a.isZero:
    return a
  if b.isZero:
    raise newException(ValueError, "&5 is not a valid divisor as divisor")
  if a.isLinearTernary.not:
    raise newException(ValueError, "only linear ternary values allowed for a: " & $a)
  if b.isLinearTernary.not:
    raise newException(ValueError, "only linear ternary values allowed for b: " & $b)

  var reminder = a
  var precision = devisionPrecision * 2
  # echo fmt"initial: {reminder} {b}"
  while reminder.isZero.not and precision > 0:
    # echo fmt"loop with reminder:{reminder} divisor:{b} result:{result}"
    let aHead = reminder.getFirstDigit()
    let bHead = b.getFirstDigit()
    var tryPosition = aHead.idx - bHead.idx
    var tryDigit = dbt5
    # echo fmt"guessing {tryDigit} at {tryPosition}, with cond {aHead} {bHead}"
    if aHead.digit == dbt1 and bHead.digit == dbt1:
      tryDigit = dbt1
    elif aHead.digit == dbt9 and bHead.digit == dbt9:
      tryDigit = dbt1
    elif aHead.digit == dbt1 and bHead.digit == dbt9:
      tryDigit = dbt9
    elif aHead.digit == dbt9 and bHead.digit == dbt1:
      tryDigit = dbt9
    else:
      raise newException(ValueError, "TODO, unknown case")
    let v = zero.addAt(tryPosition, tryDigit)
    let step = v * b
    reminder = reminder - step
    result = result + v
    precision = precision - 1
  # echo fmt"temp result: {result}"

proc `/`*(a, b: DualBalancedTernary): DualBalancedTernary =
  let cj = b.conjugate()
  let a2 = a * cj
  let b2 = b * cj # support only 1,5,9 in value now
  let splitted = a2.splitYx()
  let ay = splitted.y
  let ax = splitted.x
  # echo fmt"b.. {b} {cj} => {b2}"
  # echo fmt"splitted: {splitted} from {a2}, b2 is {b2}"
  ay.ternaryDivide(b2) + (ax.rotate7.ternaryDivide(b2).rotate3)

proc round*(a: DualBalancedTernary): DualBalancedTernary =
  DualBalancedTernary(integral: a.integral)

proc round*(a: DualBalancedTernary, n: int): DualBalancedTernary =
  if n < 0:
    raise newException(ValueError, "not supported negative number to round")
  if n > a.fractional.len:
    a
  else:
    var fractional = initDeque[DualBalancedTernaryDigit]()
    var i = 0
    while i < n:
      fractional.addLast(a.fractional[i])
      i = i + 1
    DualBalancedTernary(
      integral: a.integral,
      fractional: fractional
    )
