
import ./dual_balanced_ternary/types
import ./dual_balanced_ternary/digit

export DualBalancedTernaryDigit, DualBalancedTernary, add

# 5 is the zero point of digits, can be removed at end
proc stripEmptyTails(x: DualBalancedTernary): DualBalancedTernary =
  if (x.integral.len == 0 or x.integral[^1] != dbt5) and
    (x.fractional.len == 0 or x.fractional[^1] != dbt5):
    return x
  var y = x
  while y.integral.len > 0 and y.integral[^1] == dbt5:
    y.integral.delete(y.integral.len - 1)
  while y.fractional.len > 0 and y.fractional[^1] == dbt5:
    y.fractional.delete(y.fractional.len - 1)
  return y

proc `$`*(x: DualBalancedTernary): string =
  result = "&"
  for i in 0..<x.integral.len:
    result = result & x.integral[x.integral.len - i - 1].digitToStr
  result = result & "."
  for i in 0..<x.fractional.len:
    result = result & x.fractional[i].digitToStr

proc negate*(a: DualBalancedTernary): DualBalancedTernary =
  result = a
  for i in 0..<result.integral.len:
    result.integral[i] = result.integral[i].negate
  for i in 0..<result.fractional.len:
    result.fractional[i] = result.fractional[i].negate

proc moveBy(a: DualBalancedTernary, n: int): DualBalancedTernary =
  discard

proc add*(a, b: DualBalancedTernary): DualBalancedTernary =
  discard

proc minus*(a, b: DualBalancedTernary): DualBalancedTernary =
  discard

proc rebase*(a, b: DualBalancedTernary): DualBalancedTernary =
  discard
