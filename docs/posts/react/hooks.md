---
title: React Hooks 实战
date: 2026-05-31
tags: [React, Hooks, TypeScript]
---

# React Hooks 实战

## useState — 状态管理

```tsx
import { useState } from 'react'

interface Todo {
  id: number
  text: string
  done: boolean
}

function TodoApp() {
  const [todos, setTodos] = useState<Todo[]>([])
  const [input, setInput] = useState('')

  const addTodo = () => {
    if (!input.trim()) return
    setTodos(prev => [
      ...prev,
      { id: Date.now(), text: input.trim(), done: false },
    ])
    setInput('')
  }

  const toggleTodo = (id: number) => {
    setTodos(prev =>
      prev.map(t => (t.id === id ? { ...t, done: !t.done } : t))
    )
  }

  return (
    <div>
      <input value={input} onChange={e => setInput(e.target.value)} />
      <button onClick={addTodo}>添加</button>
      <ul>
        {todos.map(todo => (
          <li
            key={todo.id}
            onClick={() => toggleTodo(todo.id)}
            style={{ textDecoration: todo.done ? 'line-through' : 'none' }}
          >
            {todo.text}
          </li>
        ))}
      </ul>
    </div>
  )
}
```

## useEffect — 副作用

```tsx
import { useState, useEffect } from 'react'

function useWindowSize() {
  const [size, setSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight,
  })

  useEffect(() => {
    const handler = () => {
      setSize({ width: window.innerWidth, height: window.innerHeight })
    }

    window.addEventListener('resize', handler)

    // 清理函数 —— 组件卸载时移除监听
    return () => window.removeEventListener('resize', handler)
  }, []) // 空依赖数组 = 只在挂载/卸载时执行

  return size
}
```

## useCallback & useMemo

```tsx
import { useState, useCallback, useMemo } from 'react'

interface Item {
  id: number
  name: string
  price: number
  category: string
}

function ShopList({ items }: { items: Item[] }) {
  const [filter, setFilter] = useState('')
  const [sortBy, setSortBy] = useState<'price' | 'name'>('name')

  // useMemo：派生数据，仅在依赖变化时重新计算
  const filtered = useMemo(() => {
    return items
      .filter(i => i.name.includes(filter) || i.category.includes(filter))
      .sort((a, b) => {
        if (sortBy === 'price') return a.price - b.price
        return a.name.localeCompare(b.name)
      })
  }, [items, filter, sortBy])

  // useCallback：稳定化函数引用，传给子组件时避免不必要 re-render
  const handleDelete = useCallback((id: number) => {
    console.log('删除', id)
  }, [])

  return (
    <div>
      <input value={filter} onChange={e => setFilter(e.target.value)} placeholder="搜索..." />
      <select value={sortBy} onChange={e => setSortBy(e.target.value as 'price' | 'name')}>
        <option value="name">按名称</option>
        <option value="price">按价格</option>
      </select>
      <p>共 {filtered.length} 条</p>
      {filtered.map(item => (
        <ItemCard key={item.id} item={item} onDelete={handleDelete} />
      ))}
    </div>
  )
}
```

## 自定义 Hook — useFetch

```tsx
import { useState, useEffect, useRef } from 'react'

interface FetchState<T> {
  data: T | null
  loading: boolean
  error: Error | null
}

function useFetch<T>(url: string): FetchState<T> {
  const [state, setState] = useState<FetchState<T>>({
    data: null,
    loading: true,
    error: null,
  })

  // 用 ref 追踪组件是否已卸载，避免内存泄漏
  const mountedRef = useRef(true)

  useEffect(() => {
    mountedRef.current = true
    setState({ data: null, loading: true, error: null })

    const controller = new AbortController()

    fetch(url, { signal: controller.signal })
      .then(res => {
        if (!res.ok) throw new Error(`HTTP ${res.status}`)
        return res.json() as Promise<T>
      })
      .then(data => {
        if (mountedRef.current) {
          setState({ data, loading: false, error: null })
        }
      })
      .catch(err => {
        if (mountedRef.current && err.name !== 'AbortError') {
          setState({ data: null, loading: false, error: err })
        }
      })

    return () => {
      mountedRef.current = false
      controller.abort()  // 组件卸载时取消请求
    }
  }, [url])

  return state
}

// 使用
function UserProfile({ id }: { id: number }) {
  const { data, loading, error } = useFetch<{ name: string; email: string }>(
    `/api/users/${id}`
  )

  if (loading) return <p>加载中...</p>
  if (error) return <p>错误：{error.message}</p>
  if (!data) return null

  return <div>{data.name} — {data.email}</div>
}
```

::: tip 自定义 Hook 原则
- 命名以 `use` 开头
- 内部可以调用其他 Hook
- 把相关逻辑聚合，让组件代码保持简洁
:::
