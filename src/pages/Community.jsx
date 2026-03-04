import React, { useState } from 'react'
import { COMMUNITY_POSTS } from '../data'

const CURL_FILTERS = ['전체', '2A','2B','2C','3A','3B','3C','4A','4B','4C']

export default function Community({ curlType }) {
  const [posts, setPosts] = useState(COMMUNITY_POSTS)
  const [filter, setFilter] = useState('전체')
  const [showForm, setShowForm] = useState(false)
  const [liked, setLiked] = useState({})

  const filtered = filter === '전체' ? posts : posts.filter(p => p.curlType === filter)

  const toggleLike = (id) => {
    setLiked(prev => ({ ...prev, [id]: !prev[id] }))
    setPosts(ps => ps.map(p => p.id === id ? { ...p, likes: p.likes + (liked[id] ? -1 : 1) } : p))
  }

  return (
    <div className="page-content">
      <div className="top-bar">
        <h2 style={{ fontSize: 18 }}>커뮤니티</h2>
        <button
          onClick={() => setShowForm(true)}
          style={{
            padding: '8px 16px', borderRadius: 20, border: 'none',
            background: '#F2A58E', color: 'white', fontSize: 13, fontWeight: 600,
            cursor: 'pointer', fontFamily: 'inherit',
          }}
        >글 쓰기 ✏️</button>
      </div>

      <div style={{ padding: '0 20px' }}>
        {/* Filter chips */}
        <div className="scroll-row" style={{ marginBottom: 16 }}>
          {CURL_FILTERS.map(f => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              style={{
                flexShrink: 0, padding: '7px 14px', borderRadius: 20, border: 'none',
                background: filter === f ? '#F2A58E' : 'white',
                color: filter === f ? 'white' : '#7A5C4A',
                fontSize: 13, fontWeight: filter === f ? 700 : 500,
                cursor: 'pointer', fontFamily: 'inherit',
                boxShadow: '0 1px 4px rgba(61,43,31,0.08)',
                transition: 'all 0.15s',
              }}
            >{f === '전체' ? '🌿 전체' : f}</button>
          ))}
        </div>

        {/* Search bar */}
        <div style={{ position: 'relative', marginBottom: 16 }}>
          <input
            className="input-field"
            placeholder="게시글, 태그 검색..."
            style={{ paddingLeft: 40 }}
          />
          <span style={{ position: 'absolute', left: 14, top: '50%', transform: 'translateY(-50%)', fontSize: 16 }}>🔍</span>
        </div>

        {/* Posts */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          {filtered.map(post => (
            <PostCard
              key={post.id}
              post={post}
              liked={!!liked[post.id]}
              onLike={() => toggleLike(post.id)}
            />
          ))}
        </div>

        {filtered.length === 0 && (
          <div style={{ textAlign: 'center', padding: '60px 20px' }}>
            <p style={{ fontSize: 48, marginBottom: 12 }}>💬</p>
            <p style={{ fontSize: 15, color: '#7A5C4A', fontWeight: 600 }}>아직 글이 없어요</p>
            <p style={{ fontSize: 13, color: '#B89585', marginTop: 6 }}>첫 번째 글을 작성해보세요!</p>
          </div>
        )}
      </div>

      {showForm && (
        <PostForm
          curlType={curlType}
          onClose={() => setShowForm(false)}
          onSave={(post) => {
            setPosts([post, ...posts])
            setShowForm(false)
          }}
        />
      )}
    </div>
  )
}

function PostCard({ post, liked, onLike }) {
  const [showComments, setShowComments] = useState(false)
  const typeColorMap = { '2': '#F5D76E', '3': '#F4A27B', '4': '#E87070' }
  const typeColor = typeColorMap[post.curlType?.[0]] || '#F4A27B'

  return (
    <div style={{ background: 'white', borderRadius: 16, padding: 16, boxShadow: '0 2px 8px rgba(61,43,31,0.07)' }}>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
        <div className="avatar" style={{ fontSize: 18 }}>{post.avatar}</div>
        <div style={{ flex: 1 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <span style={{ fontSize: 14, fontWeight: 700, color: '#3D2B1F' }}>{post.author}</span>
            <span style={{
              fontSize: 11, padding: '2px 7px', borderRadius: 20,
              background: typeColor + '33', color: typeColor, fontWeight: 600,
            }}>{post.curlType}</span>
          </div>
        </div>
        <span style={{ fontSize: 12, color: '#B89585' }}>{post.time}</span>
      </div>

      {/* Content */}
      <p style={{ fontSize: 14, color: '#3D2B1F', lineHeight: 1.6, marginBottom: 10 }}>{post.content}</p>

      {/* Image placeholder */}
      {post.images && (
        <div style={{
          width: '100%', height: 120, borderRadius: 12, marginBottom: 10,
          background: 'linear-gradient(135deg, #FDEEE8, #D6F0ED)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 36, color: '#B89585',
        }}>📸</div>
      )}

      {/* Tags */}
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginBottom: 10 }}>
        {post.tags.map(tag => (
          <span key={tag} style={{
            fontSize: 11, padding: '3px 8px', borderRadius: 20,
            background: '#F5EBE5', color: '#7A5C4A',
          }}>#{tag}</span>
        ))}
      </div>

      {/* Actions */}
      <div style={{ display: 'flex', gap: 16, paddingTop: 8, borderTop: '1px solid #F5EBE5' }}>
        <button
          onClick={onLike}
          style={{
            background: 'none', border: 'none', cursor: 'pointer', fontFamily: 'inherit',
            display: 'flex', alignItems: 'center', gap: 4,
            fontSize: 13, color: liked ? '#E87070' : '#B89585', fontWeight: liked ? 700 : 400,
            transition: 'all 0.15s',
          }}
        >
          {liked ? '❤️' : '🤍'} {post.likes}
        </button>
        <button
          onClick={() => setShowComments(v => !v)}
          style={{
            background: 'none', border: 'none', cursor: 'pointer', fontFamily: 'inherit',
            display: 'flex', alignItems: 'center', gap: 4,
            fontSize: 13, color: '#B89585',
          }}
        >
          💬 {post.comments}
        </button>
        <button style={{
          background: 'none', border: 'none', cursor: 'pointer', fontFamily: 'inherit',
          fontSize: 13, color: '#B89585', marginLeft: 'auto',
        }}>···</button>
      </div>

      {showComments && (
        <div style={{ marginTop: 10, paddingTop: 10, borderTop: '1px solid #F5EBE5' }}>
          <div style={{ background: '#F5EBE5', borderRadius: 10, padding: '10px 12px', marginBottom: 8 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 4 }}>
              <span style={{ fontSize: 14 }}>🌸</span>
              <span style={{ fontSize: 12, fontWeight: 600, color: '#3D2B1F' }}>꼬불랑</span>
              <span style={{ fontSize: 11, color: '#B89585' }}>방금 전</span>
            </div>
            <p style={{ fontSize: 12, color: '#7A5C4A' }}>따뜻한 게시글 감사해요! 꼬불랑 커뮤니티에 오신 걸 환영해요 🌿</p>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <input className="input-field" placeholder="댓글을 입력하세요..." style={{ flex: 1, padding: '8px 12px', fontSize: 13 }} />
            <button className="btn btn-primary" style={{ padding: '8px 14px', fontSize: 13 }}>전송</button>
          </div>
        </div>
      )}
    </div>
  )
}

function PostForm({ curlType, onClose, onSave }) {
  const [content, setContent] = useState('')

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-sheet" onClick={e => e.stopPropagation()}>
        <div className="modal-handle" />
        <h3 style={{ marginBottom: 20 }}>새 게시글 작성 ✍️</h3>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16 }}>
          <div className="avatar" style={{ fontSize: 18 }}>😊</div>
          <div>
            <p style={{ fontSize: 14, fontWeight: 600, color: '#3D2B1F' }}>나</p>
            <span style={{ fontSize: 11, padding: '2px 8px', borderRadius: 20, background: '#FDEEE8', color: '#E8896E', fontWeight: 600 }}>{curlType}</span>
          </div>
        </div>
        <textarea
          value={content}
          onChange={e => setContent(e.target.value)}
          placeholder="곱슬 케어 팁, 제품 후기, 고민을 자유롭게 나눠봐요! 🌿"
          className="input-field"
          rows={5}
          style={{ resize: 'none', marginBottom: 16 }}
        />
        <div style={{ display: 'flex', gap: 10 }}>
          <button className="btn btn-secondary" style={{ flex: 1 }} onClick={onClose}>취소</button>
          <button
            className="btn btn-primary"
            style={{ flex: 2, opacity: content.trim() ? 1 : 0.5 }}
            onClick={() => {
              if (!content.trim()) return
              onSave({
                id: Date.now(),
                author: '나',
                avatar: '😊',
                curlType,
                time: '방금 전',
                content,
                likes: 0,
                comments: 0,
                tags: [],
                images: false,
              })
            }}
          >게시하기 🌸</button>
        </div>
      </div>
    </div>
  )
}
