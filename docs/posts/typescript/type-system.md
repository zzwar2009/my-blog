---
title: TypeScript 类型系统基础
date: 2026-05-31
tags: [TypeScript, 类型系统]
---

# TypeScript 类型系统基础

> TypeScript 的核心价值不是"写类型注解"，而是让编译器帮你在运行前发现错误。

## 基础类型

```ts
// 原始类型
const name: string = 'Alice'
const age: number = 25
const active: boolean = true

// 数组
const scores: number[] = [90, 85, 92]
const tags: Array<string> = ['ts', 'js']

// 元组 —— 固定长度、固定类型
const point: [number, number] = [10, 20]
const entry: [string, number] = ['age', 25]
```

## 对象类型与接口

```ts
// interface 定义形状
interface User {
  id: number
  name: string
  email?: string   // 可选属性
  readonly createdAt: Date  // 只读
}

// type alias 也可以
type Product = {
  sku: string
  price: number
  stock: number
}

// 函数类型
type Formatter = (value: number, precision?: number) => string

const formatPrice: Formatter = (value, precision = 2) =>
  `¥${value.toFixed(precision)}`
```

## 联合类型与字面量类型

```ts
// 联合类型
type Status = 'loading' | 'success' | 'error'
type ID = string | number

function handleStatus(s: Status) {
  if (s === 'loading') {
    console.log('加载中...')
  }
  // TypeScript 会在这里做穷尽检查
}

// 字面量 + 联合 = 枚举的平替
type Direction = 'up' | 'down' | 'left' | 'right'
const move = (dir: Direction, step: number) => ({ dir, step })
```

## 类型缩窄（Narrowing）

```ts
function printId(id: string | number) {
  if (typeof id === 'string') {
    // 这里 id 被缩窄为 string
    console.log(id.toUpperCase())
  } else {
    // 这里是 number
    console.log(id.toFixed(2))
  }
}

// 使用 in 操作符
interface Cat { meow(): void }
interface Dog { bark(): void }

function makeSound(animal: Cat | Dog) {
  if ('meow' in animal) {
    animal.meow()
  } else {
    animal.bark()
  }
}
```

## 实用工具类型

```ts
interface Todo {
  id: number
  title: string
  done: boolean
  tags: string[]
}

// Partial —— 所有属性变可选
type TodoUpdate = Partial<Todo>

// Required —— 所有属性变必填
type FullTodo = Required<TodoUpdate>

// Pick —— 只保留指定属性
type TodoPreview = Pick<Todo, 'id' | 'title'>

// Omit —— 排除指定属性
type TodoWithoutId = Omit<Todo, 'id'>

// Record —— 键值映射
type StatusMap = Record<Status, string>

// ReturnType —— 提取函数返回值类型
const getUser = () => ({ id: 1, name: 'Alice' })
type UserShape = ReturnType<typeof getUser>
// { id: number; name: string }
```

::: tip 小结
- 优先用 `interface` 描述对象形状，用 `type` 描述联合 / 交叉类型
- 善用工具类型，避免重复定义
- 类型缩窄是 TS 类型安全的核心机制
:::

## 下一篇

→ [泛型进阶](./generics) — 条件类型、映射类型、infer 关键字
