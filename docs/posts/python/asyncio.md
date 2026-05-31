---
title: Python 异步 asyncio
date: 2026-05-31
tags: [Python, asyncio, 异步, 并发]
---

# Python 异步 asyncio

## 协程基础

```python
import asyncio

# async def 定义协程函数
async def say_hello(name: str, delay: float):
    await asyncio.sleep(delay)  # 非阻塞等待
    print(f"Hello, {name}!")

# 运行协程
asyncio.run(say_hello("Alice", 1.0))
```

## 并发执行多个任务

```python
import asyncio
import time

async def fetch(url: str, delay: float) -> dict:
    print(f"开始请求: {url}")
    await asyncio.sleep(delay)  # 模拟网络请求
    print(f"完成请求: {url}")
    return {"url": url, "data": "..."}

async def main():
    start = time.perf_counter()

    # asyncio.gather —— 并发执行，等所有完成
    results = await asyncio.gather(
        fetch("https://api.example.com/users", 1.0),
        fetch("https://api.example.com/products", 0.5),
        fetch("https://api.example.com/orders", 0.8),
    )

    elapsed = time.perf_counter() - start
    print(f"总耗时: {elapsed:.2f}s")  # ~1.0s 而不是 2.3s
    return results

asyncio.run(main())
```

## 真实 HTTP 并发爬虫（aiohttp）

```python
import asyncio
import aiohttp
from typing import Optional

async def fetch_json(
    session: aiohttp.ClientSession,
    url: str,
    timeout: int = 10,
) -> Optional[dict]:
    try:
        async with session.get(url, timeout=aiohttp.ClientTimeout(total=timeout)) as resp:
            resp.raise_for_status()
            return await resp.json()
    except Exception as e:
        print(f"请求失败 {url}: {e}")
        return None

async def crawl(urls: list[str], concurrency: int = 10) -> list[Optional[dict]]:
    # 用信号量限制并发数
    semaphore = asyncio.Semaphore(concurrency)

    async def bounded_fetch(session: aiohttp.ClientSession, url: str):
        async with semaphore:
            return await fetch_json(session, url)

    async with aiohttp.ClientSession() as session:
        tasks = [bounded_fetch(session, url) for url in urls]
        return await asyncio.gather(*tasks)

# 使用
async def main():
    urls = [f"https://jsonplaceholder.typicode.com/posts/{i}" for i in range(1, 21)]
    results = await crawl(urls, concurrency=5)
    print(f"获取到 {sum(1 for r in results if r)} 条数据")

asyncio.run(main())
```

## asyncio.TaskGroup（Python 3.11+）

```python
import asyncio

async def process_batch(items: list[str]):
    async with asyncio.TaskGroup() as tg:
        tasks = [
            tg.create_task(process_item(item))
            for item in items
        ]
    # 所有任务完成后才继续
    return [t.result() for t in tasks]

async def process_item(item: str) -> str:
    await asyncio.sleep(0.1)
    return item.upper()
```

## 异步上下文管理器

```python
import asyncio

class AsyncDatabase:
    async def __aenter__(self):
        print("连接数据库...")
        await asyncio.sleep(0.1)  # 模拟连接
        return self

    async def __aexit__(self, exc_type, exc, tb):
        print("关闭连接...")
        await asyncio.sleep(0.05)

    async def query(self, sql: str) -> list:
        await asyncio.sleep(0.05)
        return [{"id": 1, "sql": sql}]

async def main():
    async with AsyncDatabase() as db:
        rows = await db.query("SELECT * FROM users")
        print(rows)

asyncio.run(main())
```

::: info asyncio vs 多线程
| | asyncio | 多线程 |
|--|---------|--------|
| 适合 | I/O 密集（网络、文件）| CPU 密集 |
| 切换方式 | 显式 `await`（合作式）| OS 调度（抢占式）|
| 开销 | 极低 | 较高（线程创建/切换）|
| GIL | 单线程，无 GIL 问题 | 受 GIL 限制（CPython）|
:::
