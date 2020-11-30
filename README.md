
Double balanced ternary arithmetic
----

> reimplementing in Nim.

**Double balanced ternary** is a complex number representation based on a 3x3 magic square:

```text
6 1 8
7 5 3
2 9 4
```

notating with a `&` at head, such as `&1`, `&12`, `&1.3`, `&.33`. And `&1` is the main direction, like "front".

```
&1   -> (0, 1)
&3   -> (1, 0)
&5   -> (0, 0)
&7   -> (-1, 0)
&9   -> (0, -1)
&2   -> (-1, -1)

&1   -> (0, 1)
&19  -> (0, 2)
&15  -> (0, 3)
&11  -> (0, 4)
&199 -> (0, 5)

&18  -> (1, 1)
&36  -> (2, 1)
&31  -> (3, 1)
&38  -> (4, 1)
&38  -> (4, 1)
&376 -> (5, 1)
```

similarly, it can be added, mutiplied and even divided. Notice that `&1` is the main direction for `&1 * &1 == &1` and `&5` is zero point for `&5 + &5 = &5`.

### Usage

```
requires "https://github.com/dual-balanced-ternary/dual-balanced-ternary.nim#v0.0.2"
```

```nim
import dual_balanced_ternary

echo "&1.1".parseTernary() # gets &1.1
echo "&1.1".ternary # alias

"&.3".ternary + "&45".ternary
"&.3".ternary - "&45".ternary
"&.3".ternary * "&45".ternary
"&.3".ternary / "&45".ternary

"&.3".ternary.isZero # false
"&.3".ternary.conjugate

createDualBalancedTernary(1.1, 1.2) # create from float
"&36".ternary.toFloat # (2.0, 1.0)

"&3.33".ternary.round # &3
"&3.33".ternary.round(1) # &3.3
```

### License

MIT
