---
title: TypeScript 泛型进阶
date: 2026-05-31
tags: [TypeScript, 泛型, 高级类型]
---

# TypeScript 泛型进阶

## 泛型基础回顾

```ts
// 最简单的泛型函数
function identity<T>(value: T): T {
  return value
}

// 泛型接口
interface Box<T> {
  value: T
  label: string
}

const numBox: Box<number> = { value: 42, label: 'answer' }
const strBox: Box<string> = { value: 'hello', label: 'greeting' }
```

## 泛型约束

```ts
// 使用 extends 约束 T 必须有某些属性
function getLength<T extends { length: number }>(arg: T): number {
  return arg.length
}

getLength('hello')    // 5
getLength([1, 2, 3])  // 3
// getLength(42)      // ❌ number 没有 length

// keyof 约束
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key]
}

const user = { id: 1, name: 'Alice', age: 25 }
getProperty(user, 'name')  // 'Alice'
// getProperty(user, 'xxx') // ❌ 编译错误
```

## 条件类型

```ts
// 基本语法：T extends U ? X : Y
type IsString<T> = T extends string ? true : false

type A = IsString<string>   // true
type B = IsString<number>   // false

// 实用条件类型：NonNullable
type MyNonNullable<T> = T extends null | undefined ? never : T

type C = MyNonNullable<string | null | undefined>  // string

// infer —— 从条件类型中推断类型
type UnpackPromise<T> = T extends Promise<infer U> ? U : T

type D = UnpackPromise<Promise<string>>  // string
type E = UnpackPromise<number>           // number

// 提取函数参数类型
type FirstArg<T> = T extends (first: infer F, ...rest: any[]) => any ? F : never

type F = FirstArg<(x: number, y: string) => void>  // number
```

## 映射类型

```ts
// 自己实现 Readonly
type MyReadonly<T> = {
  readonly [K in keyof T]: T[K]
}

// 自己实现 Partial
type MyPartial<T> = {
  [K in keyof T]?: T[K]
}

// 修改值类型 —— 把所有属性变成 Promise
type Promisify<T> = {
  [K in keyof T]: Promise<T[K]>
}

interface Config {
  host: string
  port: number
  debug: boolean
}

type AsyncConfig = Promisify<Config>
// { host: Promise<string>; port: Promise<number>; debug: Promise<boolean> }
```

## 模板字面量类型

```ts
type EventName = 'click' | 'focus' | 'blur'

// 自动生成 onClick / onFocus / onBlur
type Handler = `on${Capitalize<EventName>}`
// 'onClick' | 'onFocus' | 'onBlur'

// 生成 getter / setter 名称
type Getters<T extends string> = `get${Capitalize<T>}`
type Setters<T extends string> = `set${Capitalize<T>}`

type G = Getters<'name' | 'age'>   // 'getName' | 'getAge'
```

::: warning 注意
条件类型 + infer 组合很强大，但过度使用会让类型定义难以阅读。建议为复杂类型添加注释。
:::
