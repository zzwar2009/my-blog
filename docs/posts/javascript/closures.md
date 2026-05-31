---
title: JavaScript 闭包与作用域
date: 2026-05-31
tags: [JavaScript, 闭包, 作用域, 词法作用域]
---

# JavaScript 闭包与作用域

## 词法作用域

```js
const x = 'global'

function outer() {
  const x = 'outer'

  function inner() {
    // 词法作用域：inner 在定义时就确定了它能访问哪些变量
    console.log(x)  // 'outer'，而不是 'global'
  }

  inner()
}

outer()
```

## 什么是闭包

> **闭包** = 函数 + 它定义时的词法环境

```js
function makeCounter(initialValue = 0) {
  let count = initialValue  // 被闭包"关住"的变量

  return {
    increment() { count++ },
    decrement() { count-- },
    value() { return count },
  }
}

const counter = makeCounter(10)
counter.increment()
counter.increment()
console.log(counter.value())  // 12

// 每次调用 makeCounter 都会创建独立的 count
const counter2 = makeCounter(0)
counter2.increment()
console.log(counter2.value())  // 1
console.log(counter.value())   // 12 —— 互不干扰
```

## 经典闭包陷阱

```js
// ❌ 问题：var 是函数作用域，循环结束后 i = 5
for (var i = 0; i < 5; i++) {
  setTimeout(() => console.log(i), 100)
}
// 输出：5 5 5 5 5

// ✅ 解法一：改用 let（块级作用域）
for (let i = 0; i < 5; i++) {
  setTimeout(() => console.log(i), 100)
}
// 输出：0 1 2 3 4

// ✅ 解法二：IIFE 创建独立作用域（老写法，理解原理用）
for (var i = 0; i < 5; i++) {
  ;(function (j) {
    setTimeout(() => console.log(j), 100)
  })(i)
}
```

## 闭包的实际应用

### 1. 函数柯里化

```js
function curry(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn(...args)
    }
    // 返回的新函数"记住"了已传入的参数
    return (...moreArgs) => curried(...args, ...moreArgs)
  }
}

const add = curry((a, b, c) => a + b + c)

console.log(add(1)(2)(3))   // 6
console.log(add(1, 2)(3))   // 6
console.log(add(1)(2, 3))   // 6
```

### 2. 记忆化（Memoization）

```js
function memoize(fn) {
  const cache = new Map()  // 被闭包持有

  return function (...args) {
    const key = JSON.stringify(args)
    if (cache.has(key)) {
      return cache.get(key)
    }
    const result = fn.apply(this, args)
    cache.set(key, result)
    return result
  }
}

const expensiveCalc = memoize((n) => {
  console.log(`计算 ${n}...`)
  return n * n
})

expensiveCalc(5)  // 计算 5...  → 25
expensiveCalc(5)  // 直接返回缓存 → 25
expensiveCalc(6)  // 计算 6...  → 36
```

### 3. 模块模式

```js
const TodoStore = (() => {
  // 私有状态
  let todos = []
  let nextId = 1

  // 私有方法
  function findIndex(id) {
    return todos.findIndex(t => t.id === id)
  }

  // 公开 API
  return {
    add(title) {
      todos.push({ id: nextId++, title, done: false })
    },
    toggle(id) {
      const idx = findIndex(id)
      if (idx !== -1) todos[idx].done = !todos[idx].done
    },
    getAll() {
      return [...todos]  // 返回副本，防止外部直接修改
    },
  }
})()

TodoStore.add('学习闭包')
TodoStore.add('写博客')
TodoStore.toggle(1)
console.log(TodoStore.getAll())
```

::: info 小结
闭包不神秘，本质就是"函数记住了它出生时看到的变量"。理解这一点，很多模式（柯里化、记忆化、模块）就都自然了。
:::
