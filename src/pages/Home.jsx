import React from 'react'
import { CURL_TYPES, PRODUCTS, COMMUNITY_POSTS } from '../data'

export default function Home({ curlType, onNavigate }) {
  const typeInfo = CURL_TYPES.find(t => t.id === curlType) || CURL_TYPES[4]
  const recProducts = PRODUCTS.filter(p => p.types.includes(curlType)).slice(0, 4)
  const recentPosts = COMMUNITY_POSTS.slice(0, 3)

  return (
    <div className="page-content">
      {/* Top bar */}
      <div className="top-bar">
        <img src="/logo.png" alt="꼬불랑" style={{ height: 32, objectFit: 'contain', objectPosition: 'right center' }} />
        <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
          <button style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 20 }}>🔔</button>
          <button style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 20 }}>🔍</button>
        </div>
      </div>

      <div style={{ padding: '0 20px' }}>
        {/* Welcome banner */}
        <div style={{
          background: 'linear-gradient(135deg, #F2A58E 0%, #F4C4A0 50%, #5BBCB0 100%)',
          borderRadius: 20, padding: '20px 20px 16px', marginBottom: 24,
          position: 'relative', overflow: 'hidden',
        }}>
          <div style={{ position: 'absolute', right: -10, bottom: -20, opacity: 0.15, fontSize: 100 }}>🌀</div>
          <p style={{ color: 'rgba(255,255,255,0.85)', fontSize: 13, marginBottom: 4 }}>내 곱슬 유형</p>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <span style={{
              background: 'rgba(255,255,255,0.25)', borderRadius: 10, padding: '6px 14px',
              color: 'white', fontWeight: 800, fontSize: 22,
            }}>{typeInfo.id}</span>
            <div>
              <p style={{ color: 'white', fontWeight: 700, fontSize: 16 }}>{typeInfo.title}</p>
              <p style={{ color: 'rgba(255,255,255,0.85)', fontSize: 12 }}>맞춤 추천 준비됐어요 ✨</p>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 8, marginTop: 14, flexWrap: 'wrap' }}>
            {typeInfo.tips.map((tip, i) => (
              <span key={i} style={{
                background: 'rgba(255,255,255,0.2)', borderRadius: 20,
                padding: '4px 10px', color: 'white', fontSize: 11,
              }}>💡 {tip}</span>
            ))}
          </div>
        </div>

        {/* Quick actions */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 24 }}>
          {[
            { icon: '💧', label: '제품 추천', tab: 'products', bg: '#FDEEE8', color: '#E8896E' },
            { icon: '📓', label: '일지 쓰기', tab: 'diary', bg: '#D6F0ED', color: '#3A9E92' },
            { icon: '🌿', label: '커뮤니티', tab: 'community', bg: '#D9F0D6', color: '#4A9E44' },
            { icon: '👤', label: '내 프로필', tab: 'profile', bg: '#FFF0F0', color: '#B03030' },
          ].map(item => (
            <button
              key={item.tab}
              onClick={() => onNavigate(item.tab)}
              style={{
                flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
                padding: '14px 4px', borderRadius: 14, border: 'none', cursor: 'pointer',
                background: item.bg, fontFamily: 'inherit', transition: 'transform 0.15s',
              }}
              onMouseDown={e => e.currentTarget.style.transform = 'scale(0.96)'}
              onMouseUp={e => e.currentTarget.style.transform = 'scale(1)'}
            >
              <span style={{ fontSize: 22 }}>{item.icon}</span>
              <span style={{ fontSize: 11, fontWeight: 600, color: item.color }}>{item.label}</span>
            </button>
          ))}
        </div>

        {/* Recommended products */}
        <div className="section-header">
          <h3>🛍 나에게 맞는 제품</h3>
          <span className="see-all" onClick={() => onNavigate('products')}>전체보기</span>
        </div>
        <div className="scroll-row" style={{ marginBottom: 24 }}>
          {recProducts.map(product => (
            <ProductCard key={product.id} product={product} />
          ))}
          {recProducts.length === 0 && (
            <p style={{ fontSize: 13, color: '#B89585' }}>아직 등록된 추천 제품이 없어요.</p>
          )}
        </div>

        {/* Community highlights */}
        <div className="section-header">
          <h3>💬 커뮤니티 최신 글</h3>
          <span className="see-all" onClick={() => onNavigate('community')}>전체보기</span>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 24 }}>
          {recentPosts.map(post => (
            <MiniPostCard key={post.id} post={post} />
          ))}
        </div>

        {/* CTA banner */}
        <div style={{
          background: 'linear-gradient(135deg, #D6F0ED, #B8E8E3)',
          borderRadius: 18, padding: '18px 20px', marginBottom: 8,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}>
          <div>
            <p style={{ fontSize: 14, fontWeight: 700, color: '#2A7A72' }}>오늘 루틴 기록했나요?</p>
            <p style={{ fontSize: 12, color: '#4A9E92', marginTop: 2 }}>일지를 쓰면 내 패턴을 발견할 수 있어요</p>
          </div>
          <button
            className="btn btn-teal"
            style={{ padding: '10px 16px', fontSize: 13 }}
            onClick={() => onNavigate('diary')}
          >
            기록하기 ✏️
          </button>
        </div>
      </div>
    </div>
  )
}

function ProductCard({ product }) {
  return (
    <div style={{
      width: 140, flexShrink: 0, background: 'white', borderRadius: 14,
      padding: 12, boxShadow: '0 2px 8px rgba(61,43,31,0.08)',
    }}>
      <div style={{
        width: '100%', height: 80, borderRadius: 10, marginBottom: 8,
        background: '#FDEEE8', display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: 36,
      }}>{product.img}</div>
      <p style={{ fontSize: 11, color: '#B89585', marginBottom: 2 }}>{product.brand}</p>
      <p style={{ fontSize: 13, fontWeight: 600, color: '#3D2B1F', lineHeight: 1.3, marginBottom: 4 }}>{product.name}</p>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <span style={{ fontSize: 12, color: '#F5C842' }}>{'★'.repeat(Math.round(product.rating))}</span>
        <span style={{ fontSize: 12, fontWeight: 700, color: '#F2A58E' }}>{product.price}</span>
      </div>
    </div>
  )
}

function MiniPostCard({ post }) {
  const typeColorMap = { '2': '#F5D76E', '3': '#F4A27B', '4': '#E87070' }
  const typeColor = typeColorMap[post.curlType?.[0]] || '#F4A27B'
  return (
    <div style={{
      background: 'white', borderRadius: 14, padding: '14px 16px',
      boxShadow: '0 2px 8px rgba(61,43,31,0.07)',
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
        <div className="avatar">{post.avatar}</div>
        <div style={{ flex: 1 }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: '#3D2B1F' }}>{post.author}</span>
          <span style={{
            marginLeft: 6, fontSize: 11, padding: '2px 7px', borderRadius: 20,
            background: typeColor + '33', color: typeColor,
          }}>{post.curlType}</span>
        </div>
        <span style={{ fontSize: 11, color: '#B89585' }}>{post.time}</span>
      </div>
      <p style={{ fontSize: 13, color: '#3D2B1F', lineHeight: 1.5, display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>
        {post.content}
      </p>
      <div style={{ display: 'flex', gap: 12, marginTop: 10 }}>
        <span style={{ fontSize: 12, color: '#B89585' }}>❤️ {post.likes}</span>
        <span style={{ fontSize: 12, color: '#B89585' }}>💬 {post.comments}</span>
      </div>
    </div>
  )
}
