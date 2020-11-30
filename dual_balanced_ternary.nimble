# Package

version       = "0.0.2"
author        = "jiyinyiyong"
description   = "Nim implementation for dual balanced ternary"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.2.6"

task t, "Runs the test suite":
  exec "nim c --verbosity:0 --hints:off -r tests/test_math"
