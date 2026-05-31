---
title: JavaScript 异步编程深入
date: 2026-05-31
tags: [JavaScript, 异步, Promise, async/await]
---

# JavaScript 异步编程深入

## 回调地狱 → Promise

```js
// ❌ 回调地狱
fetchUser(id, (user) => {
  fetchOrders(user.id, (orders) => {
    fetchProduct(orders[0].productId, (product) => {
      console.log(product)
    })
  })
})

// ✅ Promise 链式调用
fetchUser(id)
  .then(user => fetchOrders(user.id))
  .then(orders => fetchProduct(orders[0].productId))
  .then(product => console.log(product))
  .catch(err => console.error(err))
```

## async / await

```js
async function loadProductForUser(userId) {
  try {
    const user = await fetchUser(userId)
    const orders = await fetchOrders(user.id)
    const product = await fetchProduct(orders[0].productId)
    return product
  } catch (err) {
    console.error('加载失败:', err)
    throw err
  }
}
```

## 并发控制

```js
// Promise.all —— 全部成功才继续，一个失败全失败
const [users, products, stats] = await Promise.all([
  fetchUsers(),
  fetchProducts(),
  fetchStats(),
])

// Promise.allSettled —— 不管成败都等完
const results = await Promise.allSettled([
  fetchUsers(),
  fetchProducts(),
  mightFail(),
])

results.forEach(result => {
  if (result.status === 'fulfilled') {
    console.log('成功:', result.value)
  } else {
    console.warn('失败:', result.reason)
  }
})

// Promise.race —— 谁先完成用谁（超时控制）
function withTimeout(promise, ms) {
  const timeout = new Promise((_, reject) =>
    setTimeout(() => reject(new Error(`Timeout after ${ms}ms`)), ms)
  )
  return Promise.race([promise, timeout])
}

const data = await withTimeout(fetchData(), 5000)
```

## 手写 Promise 并发限制器

```js
/**
 * 控制并发数量，最多同时运行 limit 个任务
 * @param {Array<() => Promise>} tasks
 * @param {number} limit
 */
async function runWithConcurrency(tasks, limit) {
  const results = []
  const executing = new Set()

  for (const task of tasks) {
    const promise = task().then(result => {
      executing.delete(promise)
      return result
    })

    executing.add(promise)
    results.push(promise)

    if (executing.size >= limit) {
      // 等待最快完成的那个
      await Promise.race(executing)
    }
  }

  return Promise.all(results)
}

// 用法：同时最多 3 个请求
const urls = Array.from({ length: 10 }, (_, i) => `https://api.example.com/item/${i}`)
const fetchTasks = urls.map(url => () => fetch(url).then(r => r.json()))

const allData = await runWithConcurrency(fetchTasks, 3)
```

## Event Loop 可视化

```
┌─────────────────────────────────────┐
│           Call Stack                │
│  main() → fetchUser() → ...         │
└─────────────┬───────────────────────┘
              │ Web APIs / Node APIs
              ▼
┌─────────────────────────────────────┐
│  Microtask Queue (高优先级)          │
│  Promise.then / queueMicrotask      │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Macrotask Queue (低优先级)          │
│  setTimeout / setInterval / I/O     │
└─────────────────────────────────────┘
```

::: tip 执行顺序
同步代码 → 清空微任务队列 → 取一个宏任务 → 再清空微任务队列 → 循环
:::

```js
console.log('1')  // 同步

setTimeout(() => console.log('2'), 0)  // 宏任务

Promise.resolve().then(() => console.log('3'))  // 微任务

console.log('4')  // 同步

// 输出顺序：1 → 4 → 3 → 2
```
