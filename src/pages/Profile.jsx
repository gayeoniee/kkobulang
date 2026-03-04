import React, { useState } from 'react'
import { CURL_TYPES } from '../data'

export default function Profile({ curlType, onChangeCurlType }) {
  const typeInfo = CURL_TYPES.find(t => t.id === curlType) || CURL_TYPES[4]
  const [showTypeSelector, setShowTypeSelector] = useState(false)
  const [editMode, setEditMode] = useState(false)
  const [nickname, setNickname] = useState('수진이')
  const [bio, setBio] = useState('3B 컬을 사랑하는 직장인 🌀')
  const [tempNick, setTempNick] = useState(nickname)
  const [tempBio, setTempBio] = useState(bio)
  const typeColor = typeInfo.category === 2 ? '#F5D76E' : typeInfo.category === 3 ? '#F4A27B' : '#E87070'

  const handleSave = () => {
    setNickname(tempNick)
    setBio(tempBio)
    setEditMode(false)
  }

  return (
    <div className="page-content">
      <div className="top-bar">
        <h2 style={{ fontSize: 18 }}>내 프로필</h2>
        <button
          onClick={() => { setTempNick(nickname); setTempBio(bio); setEditMode(v => !v) }}
          style={{
            padding: '7px 14px', borderRadius: 20, border: 'none',
            background: editMode ? '#EDD5C5' : '#F2A58E',
            color: editMode ? '#7A5C4A' : 'white',
            fontSize: 13, fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit',
          }}
        >{editMode ? '취소' : '수정'}</button>
      </div>

      <div style={{ padding: '0 20px' }}>
        {/* Profile header */}
        <div style={{
          background: 'white', borderRadius: 20, padding: 20, marginBottom: 16,
          boxShadow: '0 2px 12px rgba(61,43,31,0.08)',
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 16 }}>
            <div style={{
              width: 72, height: 72, borderRadius: '50%',
              background: `linear-gradient(135deg, ${typeColor}44, ${typeColor}88)`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 36, border: `3px solid ${typeColor}`,
            }}>{typeInfo.emoji}</div>
            <div style={{ flex: 1 }}>
              {editMode ? (
                <input
                  value={tempNick}
                  onChange={e => setTempNick(e.target.value)}
                  className="input-field"
                  style={{ marginBottom: 8, padding: '8px 12px', fontSize: 16 }}
                />
              ) : (
                <h2 style={{ marginBottom: 4 }}>{nickname}</h2>
              )}
              <span style={{
                fontSize: 12, padding: '3px 10px', borderRadius: 20, fontWeight: 700,
                background: typeColor + '22', color: typeColor,
              }}>{curlType} {typeInfo.title}</span>
            </div>
          </div>
          {editMode ? (
            <textarea
              value={tempBio}
              onChange={e => setTempBio(e.target.value)}
              className="input-field"
              rows={2}
              style={{ resize: 'none', marginBottom: 12 }}
            />
          ) : (
            <p style={{ fontSize: 14, color: '#7A5C4A', lineHeight: 1.5, marginBottom: 12 }}>{bio}</p>
          )}
          {editMode && (
            <button className="btn btn-primary btn-full" onClick={handleSave}>저장하기</button>
          )}

          {/* Stats */}
          <div style={{ display: 'flex', paddingTop: 14, borderTop: '1px solid #F5EBE5' }}>
            {[
              { label: '게시글', value: 3 },
              { label: '일지', value: 7 },
              { label: '팔로워', value: 12 },
            ].map(stat => (
              <div key={stat.label} style={{ flex: 1, textAlign: 'center' }}>
                <p style={{ fontSize: 18, fontWeight: 800, color: '#3D2B1F' }}>{stat.value}</p>
                <p style={{ fontSize: 12, color: '#B89585' }}>{stat.label}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Curl type card */}
        <div style={{
          background: typeColor + '18', border: `1.5px solid ${typeColor}44`,
          borderRadius: 16, padding: 16, marginBottom: 16,
        }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
            <p style={{ fontSize: 13, fontWeight: 700, color: '#3D2B1F' }}>내 곱슬 유형</p>
            <button
              onClick={() => setShowTypeSelector(true)}
              style={{
                background: 'none', border: `1px solid ${typeColor}`,
                borderRadius: 20, padding: '4px 10px', color: typeColor,
                fontSize: 12, fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit',
              }}
            >변경하기</button>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <span style={{ fontSize: 28 }}>{typeInfo.emoji}</span>
            <div>
              <p style={{ fontSize: 16, fontWeight: 800, color: '#3D2B1F' }}>{typeInfo.id} – {typeInfo.title}</p>
              <p style={{ fontSize: 13, color: '#7A5C4A', lineHeight: 1.4 }}>{typeInfo.desc}</p>
            </div>
          </div>
          <div style={{ marginTop: 10, display: 'flex', flexDirection: 'column', gap: 4 }}>
            {typeInfo.tips.map((tip, i) => (
              <div key={i} style={{ display: 'flex', gap: 6, fontSize: 12, color: '#7A5C4A' }}>
                <span>💡</span><span>{tip}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Menu items */}
        <div style={{ background: 'white', borderRadius: 16, overflow: 'hidden', boxShadow: '0 2px 8px rgba(61,43,31,0.07)', marginBottom: 16 }}>
          {[
            { icon: '📓', label: '내 다이어리', count: '7개', color: '#5BBCB0' },
            { icon: '💬', label: '내 게시글', count: '3개', color: '#F2A58E' },
            { icon: '❤️', label: '좋아요한 제품', count: '5개', color: '#E87070' },
            { icon: '🔔', label: '알림 설정', count: null, color: '#F5D76E' },
          ].map((item, i) => (
            <div key={item.label}>
              {i > 0 && <div style={{ height: 1, background: '#F5EBE5', margin: '0 16px' }} />}
              <button style={{
                width: '100%', display: 'flex', alignItems: 'center', gap: 12,
                padding: '14px 16px', background: 'none', border: 'none',
                cursor: 'pointer', fontFamily: 'inherit', textAlign: 'left',
              }}>
                <div style={{
                  width: 36, height: 36, borderRadius: 10, background: item.color + '22',
                  display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18,
                }}>{item.icon}</div>
                <span style={{ flex: 1, fontSize: 14, fontWeight: 500, color: '#3D2B1F' }}>{item.label}</span>
                {item.count && <span style={{ fontSize: 13, color: '#B89585' }}>{item.count}</span>}
                <span style={{ color: '#B89585' }}>›</span>
              </button>
            </div>
          ))}
        </div>

        {/* Account */}
        <div style={{ background: 'white', borderRadius: 16, overflow: 'hidden', boxShadow: '0 2px 8px rgba(61,43,31,0.07)', marginBottom: 24 }}>
          {['계정 관리', '개인정보 처리방침', '로그아웃'].map((item, i) => (
            <div key={item}>
              {i > 0 && <div style={{ height: 1, background: '#F5EBE5', margin: '0 16px' }} />}
              <button style={{
                width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                padding: '14px 16px', background: 'none', border: 'none',
                cursor: 'pointer', fontFamily: 'inherit',
              }}>
                <span style={{ fontSize: 14, color: item === '로그아웃' ? '#E87070' : '#3D2B1F' }}>{item}</span>
                {item !== '로그아웃' && <span style={{ color: '#B89585' }}>›</span>}
              </button>
            </div>
          ))}
        </div>
      </div>

      {showTypeSelector && (
        <TypeSelectorModal
          current={curlType}
          onClose={() => setShowTypeSelector(false)}
          onSelect={(id) => { onChangeCurlType(id); setShowTypeSelector(false) }}
        />
      )}
    </div>
  )
}

function TypeSelectorModal({ current, onClose, onSelect }) {
  const [selected, setSelected] = useState(current)
  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-sheet" style={{ maxHeight: '80dvh' }} onClick={e => e.stopPropagation()}>
        <div className="modal-handle" />
        <h3 style={{ marginBottom: 6 }}>곱슬 유형 변경</h3>
        <p style={{ fontSize: 13, color: '#B89585', marginBottom: 16 }}>나에게 가장 맞는 유형을 선택해주세요</p>
        <div style={{ overflowY: 'auto', maxHeight: 'calc(80dvh - 140px)', display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 16 }}>
          {CURL_TYPES.map(type => {
            const tColor = type.category === 2 ? '#F5D76E' : type.category === 3 ? '#F4A27B' : '#E87070'
            return (
              <button
                key={type.id}
                onClick={() => setSelected(type.id)}
                style={{
                  display: 'flex', alignItems: 'center', gap: 12, padding: '12px 14px',
                  borderRadius: 12, border: selected === type.id ? `2px solid ${tColor}` : '2px solid transparent',
                  background: selected === type.id ? tColor + '18' : '#F5EBE5',
                  cursor: 'pointer', textAlign: 'left', fontFamily: 'inherit',
                  transition: 'all 0.15s',
                }}
              >
                <span style={{ fontSize: 22 }}>{type.emoji}</span>
                <div>
                  <span style={{ fontSize: 14, fontWeight: 700, color: '#3D2B1F' }}>{type.id}</span>
                  <span style={{ fontSize: 13, color: '#7A5C4A', marginLeft: 6 }}>{type.title}</span>
                </div>
                {selected === type.id && <span style={{ marginLeft: 'auto', color: tColor, fontSize: 18 }}>✓</span>}
              </button>
            )
          })}
        </div>
        <button className="btn btn-primary btn-full" onClick={() => onSelect(selected)}>
          {selected}으로 변경하기
        </button>
      </div>
    </div>
  )
}
