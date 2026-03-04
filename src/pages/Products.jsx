import React, { useState } from 'react'
import { PRODUCTS, CURL_TYPES } from '../data'

const CATEGORIES = [
  { id: 'all', label: '전체', icon: '✨' },
  { id: 'shampoo', label: '샴푸', icon: '🧴' },
  { id: 'treatment', label: '트리트먼트', icon: '💆' },
  { id: 'curlcream', label: '컬 크림', icon: '🌀' },
]

export default function Products({ curlType }) {
  const [category, setCategory] = useState('all')
  const [filterByType, setFilterByType] = useState(true)
  const [selected, setSelected] = useState(null)

  const filtered = PRODUCTS.filter(p => {
    const catMatch = category === 'all' || p.category === category
    const typeMatch = !filterByType || p.types.includes(curlType)
    return catMatch && typeMatch
  })

  if (selected) {
    return <ProductDetail product={selected} curlType={curlType} onBack={() => setSelected(null)} />
  }

  return (
    <div className="page-content">
      <div className="top-bar">
        <h2 style={{ fontSize: 18 }}>제품 추천</h2>
        <button
          onClick={() => setFilterByType(f => !f)}
          style={{
            padding: '6px 12px', borderRadius: 20, border: 'none', cursor: 'pointer',
            background: filterByType ? '#F2A58E' : '#EDD5C5',
            color: filterByType ? 'white' : '#7A5C4A',
            fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
            display: 'flex', alignItems: 'center', gap: 4,
          }}
        >
          {filterByType ? `✓ ${curlType} 맞춤` : '전체 보기'}
        </button>
      </div>

      <div style={{ padding: '0 20px' }}>
        {/* Category tabs */}
        <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
          {CATEGORIES.map(cat => (
            <button
              key={cat.id}
              onClick={() => setCategory(cat.id)}
              style={{
                padding: '8px 14px', borderRadius: 20, border: 'none', cursor: 'pointer',
                background: category === cat.id ? '#F2A58E' : 'white',
                color: category === cat.id ? 'white' : '#7A5C4A',
                fontSize: 13, fontWeight: 600, fontFamily: 'inherit',
                boxShadow: '0 1px 4px rgba(61,43,31,0.08)',
                transition: 'all 0.15s',
                display: 'flex', alignItems: 'center', gap: 4,
              }}
            >
              <span>{cat.icon}</span>{cat.label}
            </button>
          ))}
        </div>

        {/* Result count */}
        <p style={{ fontSize: 13, color: '#B89585', marginBottom: 14 }}>
          {filtered.length}개의 제품
          {filterByType && ` · ${curlType} 유형 맞춤`}
        </p>

        {/* Product grid */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          {filtered.map(product => (
            <button
              key={product.id}
              onClick={() => setSelected(product)}
              style={{
                background: 'white', borderRadius: 16, padding: 14,
                boxShadow: '0 2px 8px rgba(61,43,31,0.08)',
                border: 'none', cursor: 'pointer', textAlign: 'left',
                fontFamily: 'inherit', transition: 'transform 0.15s',
              }}
              onMouseDown={e => e.currentTarget.style.transform = 'scale(0.97)'}
              onMouseUp={e => e.currentTarget.style.transform = 'scale(1)'}
            >
              <div style={{
                width: '100%', aspectRatio: '1', borderRadius: 12, marginBottom: 10,
                background: '#FDEEE8', display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 42,
              }}>{product.img}</div>
              <p style={{ fontSize: 10, color: '#B89585', marginBottom: 3 }}>{product.brand}</p>
              <p style={{ fontSize: 13, fontWeight: 600, color: '#3D2B1F', lineHeight: 1.3, marginBottom: 6 }}>{product.name}</p>
              <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginBottom: 6 }}>
                <span style={{ color: '#F5C842', fontSize: 11 }}>★ {product.rating}</span>
                <span style={{ color: '#B89585', fontSize: 11 }}>({product.reviewCount})</span>
              </div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4, marginBottom: 8 }}>
                {product.tags.slice(0, 2).map(tag => (
                  <span key={tag} style={{
                    fontSize: 10, padding: '2px 7px', borderRadius: 10,
                    background: '#FDEEE8', color: '#E8896E',
                  }}>#{tag}</span>
                ))}
              </div>
              <p style={{ fontSize: 14, fontWeight: 700, color: '#F2A58E' }}>{product.price}</p>
            </button>
          ))}
        </div>

        {filtered.length === 0 && (
          <div style={{ textAlign: 'center', padding: '60px 20px' }}>
            <p style={{ fontSize: 36, marginBottom: 12 }}>🔍</p>
            <p style={{ fontSize: 15, color: '#7A5C4A', fontWeight: 600 }}>해당 조건의 제품이 없어요</p>
            <p style={{ fontSize: 13, color: '#B89585', marginTop: 6 }}>필터를 변경해 보세요</p>
          </div>
        )}

        {/* Request product */}
        <div style={{
          margin: '20px 0', padding: '16px', background: '#FFF8EF',
          border: '1.5px dashed #EDD5C5', borderRadius: 14, textAlign: 'center',
        }}>
          <p style={{ fontSize: 13, color: '#7A5C4A', marginBottom: 8 }}>찾는 제품이 없나요?</p>
          <button style={{
            background: 'none', border: '1.5px solid #F2A58E', borderRadius: 20,
            padding: '8px 18px', color: '#F2A58E', fontSize: 13, fontWeight: 600,
            cursor: 'pointer', fontFamily: 'inherit',
          }}>+ 제품 등록 신청하기</button>
        </div>
      </div>
    </div>
  )
}

function ProductDetail({ product, curlType, onBack }) {
  const [liked, setLiked] = useState(false)
  const typeMatch = product.types.includes(curlType)
  return (
    <div className="page-content">
      <div className="top-bar">
        <button onClick={onBack} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 22, color: '#3D2B1F' }}>←</button>
        <button onClick={() => setLiked(l => !l)} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 22 }}>
          {liked ? '❤️' : '🤍'}
        </button>
      </div>
      <div style={{ padding: '0 20px 20px' }}>
        <div style={{
          width: '100%', height: 200, borderRadius: 20, marginBottom: 20,
          background: 'linear-gradient(135deg, #FDEEE8, #FFF8EF)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 80,
        }}>{product.img}</div>

        {typeMatch && (
          <div style={{
            background: '#D6F0ED', borderRadius: 10, padding: '8px 14px', marginBottom: 14,
            display: 'inline-flex', alignItems: 'center', gap: 6,
          }}>
            <span style={{ fontSize: 14 }}>✅</span>
            <span style={{ fontSize: 13, color: '#3A9E92', fontWeight: 600 }}>{curlType} 유형에 추천하는 제품이에요!</span>
          </div>
        )}

        <p style={{ fontSize: 12, color: '#B89585', marginBottom: 4 }}>{product.brand}</p>
        <h2 style={{ marginBottom: 8 }}>{product.name}</h2>

        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 14 }}>
          <span style={{ color: '#F5C842', fontSize: 16 }}>{'★'.repeat(Math.round(product.rating))}</span>
          <span style={{ fontSize: 14, fontWeight: 600, color: '#3D2B1F' }}>{product.rating}</span>
          <span style={{ fontSize: 13, color: '#B89585' }}>({product.reviewCount}개 리뷰)</span>
        </div>

        <p style={{ fontSize: 22, fontWeight: 800, color: '#F2A58E', marginBottom: 16 }}>{product.price}</p>

        <div className="divider" style={{ margin: '0 -20px 16px' }} />

        <h3 style={{ marginBottom: 8 }}>제품 설명</h3>
        <p style={{ fontSize: 14, color: '#7A5C4A', lineHeight: 1.7, marginBottom: 16 }}>{product.desc}</p>

        <h3 style={{ marginBottom: 8 }}>태그</h3>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 16 }}>
          {product.tags.map(tag => (
            <span key={tag} style={{
              padding: '6px 12px', borderRadius: 20, background: '#FDEEE8',
              color: '#E8896E', fontSize: 13, fontWeight: 500,
            }}>#{tag}</span>
          ))}
        </div>

        <h3 style={{ marginBottom: 8 }}>맞는 곱슬 유형</h3>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 24 }}>
          {product.types.map(t => {
            const info = CURL_TYPES.find(c => c.id === t)
            const isMe = t === curlType
            return (
              <span key={t} style={{
                padding: '6px 12px', borderRadius: 20, fontSize: 13, fontWeight: 600,
                background: isMe ? '#F2A58E' : '#F5EBE5',
                color: isMe ? 'white' : '#7A5C4A',
              }}>{t}{info ? ` ${info.title}` : ''}</span>
            )
          })}
        </div>

        <button className="btn btn-primary btn-full" style={{ fontSize: 16 }}>
          구매 링크 보기 →
        </button>
      </div>
    </div>
  )
}
