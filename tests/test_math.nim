
import unittest

import dual_balanced_ternary

test "math":
  echo "&1.1".parseTernary()
  echo "&1.15".parseTernary()
  echo "&51.1".parseTernary()
  echo "&51.15".parseTernary()

test "can add":
  check add(dbt1, dbt1) == (dbt1, dbt9)
