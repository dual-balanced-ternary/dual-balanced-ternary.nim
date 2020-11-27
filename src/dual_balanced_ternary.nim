
import deques

import ./dual_balanced_ternary/types
import ./dual_balanced_ternary/digit

export DualBalancedTernaryDigit, DualBalancedTernary, add, `$`, parseTernaryDigit, parseTernary

proc negate*(a: DualBalancedTernary): DualBalancedTernary =
  result = a
  for i in 0..<result.integral.len:
    result.integral[i] = result.integral[i].negate
  for i in 0..<result.fractional.len:
    result.fractional[i] = result.fractional[i].negate

# positive number to make value larger
proc moveBy(a: DualBalancedTernary, n: int): DualBalancedTernary =
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
    for i in 0..<n:
      if b.integral.len == 0:
        b.fractional.addFirst dbt5
      else:
        b.fractional.addFirst b.integral.popFirst
  return b

proc add*(a, b: DualBalancedTernary): DualBalancedTernary =
  discard

proc minus*(a, b: DualBalancedTernary): DualBalancedTernary =
  discard

proc rebase*(a, b: DualBalancedTernary): DualBalancedTernary =
  discard
