---
title: Python 装饰器详解
date: 2026-05-31
tags: [Python, 装饰器, 函数式编程]
---

# Python 装饰器详解

> 装饰器本质是：**接收一个函数，返回一个增强版函数**的高阶函数。

## 基础装饰器

```python
import functools
import time

def timer(func):
    """测量函数运行时间"""
    @functools.wraps(func)  # 保留原函数的 __name__ 等元信息
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"{func.__name__} 耗时 {elapsed:.4f}s")
        return result
    return wrapper

@timer
def slow_sum(n: int) -> int:
    return sum(range(n))

slow_sum(10_000_000)
# slow_sum 耗时 0.3142s
```

## 带参数的装饰器

```python
import functools
import time

def retry(max_attempts: int = 3, delay: float = 1.0):
    """自动重试装饰器"""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            last_error = None
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_error = e
                    print(f"第 {attempt} 次失败: {e}")
                    if attempt < max_attempts:
                        time.sleep(delay)
            raise last_error
        return wrapper
    return decorator

@retry(max_attempts=3, delay=0.5)
def unstable_api_call(url: str) -> dict:
    import random
    if random.random() < 0.7:
        raise ConnectionError("网络错误")
    return {"status": "ok", "url": url}
```

## 缓存装饰器（手写 + 标准库）

```python
import functools

# 手写简单版
def memoize(func):
    cache = {}
    @functools.wraps(func)
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return wrapper

@memoize
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# 标准库版：functools.lru_cache
from functools import lru_cache

@lru_cache(maxsize=128)
def heavy_computation(n: int) -> int:
    return sum(i ** 2 for i in range(n))

# Python 3.9+ 推荐：functools.cache（无大小限制）
from functools import cache

@cache
def dp(n: int) -> int:
    if n <= 1:
        return n
    return dp(n - 1) + dp(n - 2)
```

## 类装饰器

```python
from dataclasses import dataclass
from functools import wraps

class Validate:
    """验证参数的类装饰器"""
    def __init__(self, **validators):
        self.validators = validators  # {'age': lambda x: x > 0}

    def __call__(self, func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # 只验证 kwargs
            for key, validate in self.validators.items():
                if key in kwargs and not validate(kwargs[key]):
                    raise ValueError(f"参数 {key}={kwargs[key]} 验证失败")
            return func(*args, **kwargs)
        return wrapper

@Validate(age=lambda x: 0 < x < 150, name=lambda x: len(x) >= 2)
def create_user(name: str, age: int) -> dict:
    return {"name": name, "age": age}

create_user(name="Alice", age=25)   # OK
# create_user(name="A", age=25)     # ValueError: 参数 name=A 验证失败
```

## 叠加多个装饰器

```python
@timer
@retry(max_attempts=2)
@memoize
def fetch_data(url: str) -> dict:
    ...

# 等价于：
# fetch_data = timer(retry(max_attempts=2)(memoize(fetch_data)))
# 执行顺序（从外到内）：timer → retry → memoize → 原函数
```

::: tip 记住
- 始终用 `@functools.wraps(func)` 保留元信息
- 带参数的装饰器需要三层函数
- 叠加时从下往上应用，从外往内执行
:::
