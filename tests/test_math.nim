
import unittest

import dual_balanced_ternary

test "equality":
  check "&1.1".parseTernary() == "&1.1".parseTernary()
  check "&1.1".parseTernary() == "&1.15".parseTernary()
  check "&1.1".parseTernary() == "&51.1".parseTernary()
  check "&1.5".parseTernary() == "&1".parseTernary()
  check "&1.1".parseTernary() != "&1.5".parseTernary()
  check "&.".parseTernary() == "&.5".parseTernary()
  check "&.".parseTernary() == "&5.".parseTernary()
  check "&.".parseTernary() == "&5.5".parseTernary()

test "parse and format":
  check $"&1.1".parseTernary() == "&1.1"
  check $"&1.15".parseTernary() == "&1.1"
  check $"&51.1".parseTernary() == "&1.1"
  check $"&51.15".parseTernary() == "&1.1"

  check $"&1.1".parseTernary().moveBy(1) == "&11"
  check $"&1.1".parseTernary().moveBy(-1) == "&.11"

test "negate":
  check "&1.1".parseTernary().negate == "&9.9".parseTernary()
  check "&5".parseTernary().negate == "&5".parseTernary()
  check "&4".parseTernary().negate == "&6".parseTernary()
  check "&4.63".parseTernary().negate == "&6.47".parseTernary()

test "addAt":
  check "&1.1".parseTernary().addAt(0, dbt1) == "&19.1".parseTernary()
  check "&1.1".parseTernary().addAt(-1, dbt1) == "&19.9".parseTernary()
  check "&1.1".parseTernary().addAt(-1, dbt9) == "&1.".parseTernary()
  check "&1.1".parseTernary().addAt(-1, dbt5) == "&1.1".parseTernary()
  check "&1.1".parseTernary().addAt(0, dbt7) == "&6.1".parseTernary()
  check "&1.1".parseTernary().addAt(1, dbt7) == "&71.1".parseTernary()
  check "&1.1".parseTernary().addAt(2, dbt7) == "&751.1".parseTernary()
  check "&1.1".parseTernary().addAt(-2, dbt7) == "&1.17".parseTernary()
  check "&1.1".parseTernary().addAt(-3, dbt7) == "&1.157".parseTernary()

  check "&6.6".parseTernary().addAt(0, dbt6) == "&64.6".parseTernary()
  check "&6.6".parseTernary().addAt(1, dbt6) == "&66.6".parseTernary()
  check "&6.6".parseTernary().addAt(-1, dbt6) == "&64.4".parseTernary()
  check "&6.6".parseTernary().addAt(-2, dbt6) == "&6.66".parseTernary()

  check "&19.9".ternary.addAt(0, dbt1) == "&15.9".ternary

test "can add":
  check "&1.1".ternary + "&9.9".ternary == "&5".ternary
  check "&1.1".ternary + "&1.1".ternary == "&15.9".ternary
  check "&1.6".ternary + "&1.6".ternary == "&17.4".ternary

test "float":
  check "&4".ternary.toFloat == (1.0, -1.0)
  check "&5".ternary.toFloat == (0.0, 0.0)
  check "&13".ternary.toFloat == (1.0, 3.0)
  check "&66".ternary.toFloat == (-4.0, 4.0)
  check "&.1".ternary.toFloat == (0.0, 1/3)
  check "&.4".ternary.toFloat == (1/3, -1/3)
  check "&.7".ternary.toFloat == (-1/3, 0.0)

  check createDualBalancedTernary(4,6) == "&143".ternary
  check createDualBalancedTernary(4,4) == "&88".ternary
  check createDualBalancedTernary(-4,-4) == "&22".ternary
  check createDualBalancedTernary(1,7) == "&198".ternary

  echo createDualBalancedTernary(1.1, 1.1)
  echo createDualBalancedTernary(1.2, -1.2)
  echo createDualBalancedTernary(-1.3, 1.3)
  echo createDualBalancedTernary(-1.4, -1.4)
  check createDualBalancedTernary(0.0, 0.0) == "&5".ternary

test "minus":
  check "&15".ternary - "&6".ternary == "&14".ternary
  check "&44".ternary - "&44".ternary == "&5".ternary

test "multiply":
  check "&1".ternary * "&3".ternary == "&3".ternary
  check "&3".ternary * "&3".ternary == "&9".ternary
  check "&3".ternary * "&4".ternary == "&2".ternary

  check "&35".ternary * "&4".ternary == "&25".ternary
  check "&35".ternary * "&45".ternary == "&255".ternary

  check "&.3".ternary * "&4".ternary == "&.2".ternary
  check "&.3".ternary * "&.4".ternary == "&.52".ternary
  check "&.3".ternary * "&45".ternary == "&2".ternary

  check "&23".ternary * "&47".ternary == "&111".ternary
  check "&616".ternary * "&751".ternary == "&743316".ternary
  check "&616".ternary * "&751".ternary == "&743316".ternary
  check "&751".ternary * "&616".ternary == "&743316".ternary

  check "&3.3".ternary * "&1.3".ternary == "&3.49".ternary
  check "&.5536".ternary * "&.5543".ternary == "&.55555928".ternary

test "divide":
  # echo "dividing...."
  check ("&15".ternary / "&1".ternary) == "&15".ternary
  check ("&111".ternary / "&23".ternary) == "&47".ternary
  check ("&743316".ternary / "&616".ternary) == "&751".ternary
  check ("&743316".ternary / "&751".ternary) == "&616".ternary

  check "&3.49".ternary / "&3.3".ternary == "&1.3".ternary
  check "&3.49".ternary / "&1.3".ternary == "&3.3".ternary

  check "&.55555928".ternary / "&.5536".ternary == "&.5543".ternary

  echo "&743317".ternary / "&616".ternary # not exact division

  # there was a bug in mutiply conjugated values
  check "&9.41658555559".ternary / "&9.51372555559".ternary == "&1.653732945268634852684471755515159".ternary

test "round":
  check "&2.4".ternary.round == "&2".ternary
  check "&2.444".ternary.round(0) == "&2".ternary
  check "&2.444".ternary.round(1) == "&2.4".ternary
  check "&2.444".ternary.round(2) == "&2.44".ternary
  check "&2.444".ternary.round(3) == "&2.444".ternary
  check "&2.444".ternary.round(4) == "&2.444".ternary

test "hashes":
  check "&1".ternary != "&15".ternary
  check "&1".ternary != "&.1".ternary
  check "&1".ternary == "&1.5".ternary
  check "&1".ternary == "&51".ternary

  echo hash("&.1".ternary)
  echo hash("&1".ternary)
  echo hash("&19".ternary)
  echo hash("&15".ternary)
  echo hash("&11".ternary)
