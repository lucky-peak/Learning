# Python `==` vs `is` — 解释器验证记录

> 来源：CPython 3.x 解释器实测 + Python 官方文档。验证日期：2026-09-28。

## 实测结果

```python
[] == []        # True
[] is []        # False
[1,2] == [1,2]  # True
[1,2] is [1,2]  # False
[1] is [1]      # False
```

- 小整数缓存边界（跨编译单元，模拟 REPL 逐行求值）：
  - `eval("256") is eval("256")` → `True`
  - `eval("257") is eval("257")` → `False`
- 字符串 intern：`'a' is 'a'` → `True`
- Python 3.8+ 对 `is` 接字面量（如 `5 is 5`）给出 `SyntaxWarning: "is" with 'int' literal`。

## 结论

`==` 比值（list 逐元素递归），`is` 比身份（同一对象）。`[]` 字面量每次求值都新造一个列表。

## 出处

- https://docs.python.org/3/reference/datamodel.html
- https://docs.python.org/3/reference/expressions.html#comparisons
- https://docs.python.org/3/reference/expressions.html#is
