---
title: React 性能优化
date: 2026-05-31
tags: [React, 性能优化, memo, 虚拟化]
---

# React 性能优化

## React.memo — 阻止不必要的 re-render

```tsx
import { memo, useState } from 'react'

interface CardProps {
  title: string
  count: number
  onIncrement: () => void
}

// memo：props 不变就不重渲染
const Card = memo<CardProps>(({ title, count, onIncrement }) => {
  console.log(`渲染: ${title}`)
  return (
    <div>
      <h3>{title}: {count}</h3>
      <button onClick={onIncrement}>+1</button>
    </div>
  )
})

// 自定义比较函数（可选）
const HeavyCard = memo(
  ({ data }: { data: Record<string, any> }) => <div>{JSON.stringify(data)}</div>,
  (prev, next) => prev.data.id === next.data.id  // 只比较 id
)
```

## 代码分割 & 懒加载

```tsx
import { lazy, Suspense, useState } from 'react'

// 路由级别懒加载
const Dashboard = lazy(() => import('./pages/Dashboard'))
const Settings = lazy(() => import('./pages/Settings'))

// 组件级别懒加载（大型弹窗、图表等）
const HeavyChart = lazy(() =>
  import('./components/HeavyChart').then(m => ({ default: m.HeavyChart }))
)

function App() {
  const [page, setPage] = useState<'dashboard' | 'settings'>('dashboard')

  return (
    <Suspense fallback={<div className="spinner">加载中...</div>}>
      {page === 'dashboard' ? <Dashboard /> : <Settings />}
    </Suspense>
  )
}
```

## 虚拟化长列表

```tsx
// 使用 @tanstack/react-virtual 渲染超长列表
import { useVirtualizer } from '@tanstack/react-virtual'
import { useRef } from 'react'

interface Row {
  id: number
  name: string
  value: string
}

function VirtualList({ rows }: { rows: Row[] }) {
  const parentRef = useRef<HTMLDivElement>(null)

  const virtualizer = useVirtualizer({
    count: rows.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 48,      // 预估行高
    overscan: 10,                // 多渲染 10 行（缓冲）
  })

  return (
    <div
      ref={parentRef}
      style={{ height: '500px', overflow: 'auto' }}
    >
      {/* 占位高度 */}
      <div style={{ height: virtualizer.getTotalSize() + 'px', position: 'relative' }}>
        {virtualizer.getVirtualItems().map(vRow => (
          <div
            key={vRow.key}
            style={{
              position: 'absolute',
              top: vRow.start + 'px',
              left: 0,
              right: 0,
              height: vRow.size + 'px',
              display: 'flex',
              alignItems: 'center',
              padding: '0 16px',
              borderBottom: '1px solid #eee',
            }}
          >
            <span>{rows[vRow.index].name}</span>
            <span>{rows[vRow.index].value}</span>
          </div>
        ))}
      </div>
    </div>
  )
}
```

## useTransition — 非紧急更新降级

```tsx
import { useState, useTransition } from 'react'

function SearchWithTransition() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<string[]>([])
  const [isPending, startTransition] = useTransition()

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    // 输入框更新是紧急的 → 立即执行
    setQuery(e.target.value)

    // 搜索结果更新是非紧急的 → 可以被打断
    startTransition(() => {
      setResults(heavySearch(e.target.value))
    })
  }

  return (
    <div>
      <input value={query} onChange={handleChange} placeholder="搜索..." />
      {isPending && <span>搜索中...</span>}
      <ul>
        {results.map((r, i) => <li key={i}>{r}</li>)}
      </ul>
    </div>
  )
}

function heavySearch(q: string): string[] {
  // 模拟耗时过滤
  return Array.from({ length: 1000 }, (_, i) => `结果 ${i}`).filter(s =>
    s.includes(q)
  )
}
```

::: warning 优化原则
1. **先测量，再优化** — 用 React DevTools Profiler 找真正的瓶颈
2. **memo 不是免费的** — 比较本身也有开销，props 很稳定时才有价值
3. **key 要稳定** — 避免用数组下标作 key，会导致不必要的重建
:::
