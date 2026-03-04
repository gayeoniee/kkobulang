import React, { useState } from 'react'
import { DIARY_ENTRIES, PRODUCTS } from '../data'

const RESULT_EMOJIS = ['😞', '😕', '😐', '😊', '🥰']

export default function Diary() {
  const [entries, setEntries] = useState(DIARY_ENTRIES)
  const [showForm, setShowForm] = useState(false)

  return (
    <div className="page-content">
      <div className="top-bar">
        <h2 style={{ fontSize: 18 }}>헤어 다이어리</h2>
        <button
          onClick={() => setShowForm(true)}
          style={{
            padding: '8px 16px', borderRadius: 20, border: 'none',
            background: '#F2A58E', color: 'white', fontSize: 13, fontWeight: 600,
            cursor: 'pointer', fontFamily: 'inherit',
            display: 'flex', alignItems: 'center', gap: 4,
          }}
        >+ 기록하기</button>
      </div>

      <div style={{ padding: '0 20px' }}>
        {/* Stats */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 20 }}>
          {[
            { label: '총 기록', value: entries.length, unit: '일', bg: '#FDEEE8', color: '#E8896E' },
            { label: '이번 달', value: 2, unit: '회', bg: '#D6F0ED', color: '#3A9E92' },
            { label: '연속 기록', value: 3, unit: '일', bg: '#D9F0D6', color: '#4A9E44' },
          ].map(stat => (
            <div key={stat.label} style={{
              flex: 1, background: stat.bg, borderRadius: 14, padding: '12px 10px', textAlign: 'center',
            }}>
              <p style={{ fontSize: 22, fontWeight: 800, color: stat.color }}>{stat.value}<span style={{ fontSize: 13 }}>{stat.unit}</span></p>
              <p style={{ fontSize: 11, color: stat.color, opacity: 0.8, marginTop: 2 }}>{stat.label}</p>
            </div>
          ))}
        </div>

        {/* Badge row */}
        <div style={{ marginBottom: 20 }}>
          <p style={{ fontSize: 13, fontWeight: 600, color: '#3D2B1F', marginBottom: 10 }}>🏅 획득한 뱃지</p>
          <div style={{ display: 'flex', gap: 10 }}>
            {[
              { icon: '🌱', label: '첫 기록', earned: true },
              { icon: '🔥', label: '3일 연속', earned: true },
              { icon: '💫', label: '7일 연속', earned: false },
              { icon: '🏆', label: '30일 달성', earned: false },
            ].map(badge => (
              <div key={badge.label} style={{
                flex: 1, background: badge.earned ? 'white' : '#F5EBE5',
                borderRadius: 12, padding: '10px 4px', textAlign: 'center',
                boxShadow: badge.earned ? '0 2px 8px rgba(61,43,31,0.1)' : 'none',
                opacity: badge.earned ? 1 : 0.5,
              }}>
                <p style={{ fontSize: 22 }}>{badge.icon}</p>
                <p style={{ fontSize: 10, color: '#7A5C4A', marginTop: 4 }}>{badge.label}</p>
              </div>
            ))}
          </div>
        </div>

        <div className="divider" style={{ margin: '0 -20px 20px' }} />

        {/* Entries */}
        <p style={{ fontSize: 14, fontWeight: 700, color: '#3D2B1F', marginBottom: 12 }}>최근 기록</p>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          {entries.map(entry => (
            <DiaryCard key={entry.id} entry={entry} />
          ))}
        </div>

        {entries.length === 0 && (
          <div style={{ textAlign: 'center', padding: '60px 20px' }}>
            <p style={{ fontSize: 48, marginBottom: 12 }}>📓</p>
            <p style={{ fontSize: 15, color: '#7A5C4A', fontWeight: 600 }}>아직 기록이 없어요</p>
            <p style={{ fontSize: 13, color: '#B89585', marginTop: 6 }}>오늘의 헤어 루틴을 기록해봐요!</p>
          </div>
        )}
      </div>

      {showForm && (
        <DiaryForm
          onClose={() => setShowForm(false)}
          onSave={(entry) => {
            setEntries([entry, ...entries])
            setShowForm(false)
          }}
        />
      )}
    </div>
  )
}

function DiaryCard({ entry }) {
  const resultScore = parseInt(entry.result) || 3
  const emoji = RESULT_EMOJIS[resultScore - 1]
  const resultColor = ['#E87070', '#F4A27B', '#F5D76E', '#6BBF5F', '#5BBCB0'][resultScore - 1]

  return (
    <div style={{ background: 'white', borderRadius: 16, padding: '16px', boxShadow: '0 2px 8px rgba(61,43,31,0.07)' }}>
      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
        <div style={{
          width: 44, height: 44, borderRadius: 12, background: '#FDEEE8',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 24, flexShrink: 0,
        }}>{entry.mood}</div>
        <div style={{ flex: 1 }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ fontSize: 13, color: '#B89585' }}>{entry.date}</span>
            <span style={{
              fontSize: 13, padding: '2px 8px', borderRadius: 20,
              background: resultColor + '22', color: resultColor, fontWeight: 600,
            }}>{emoji} {entry.result}</span>
          </div>
          <p style={{ fontSize: 14, color: '#3D2B1F', lineHeight: 1.5, marginTop: 6 }}>{entry.memo}</p>
        </div>
      </div>
      <div style={{ marginTop: 10, paddingTop: 10, borderTop: '1px solid #F5EBE5' }}>
        <p style={{ fontSize: 11, color: '#B89585', marginBottom: 6 }}>사용한 제품</p>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
          {entry.routine.map((r, i) => (
            <span key={i} style={{
              fontSize: 11, padding: '3px 9px', borderRadius: 20,
              background: '#F5EBE5', color: '#7A5C4A',
            }}>{r}</span>
          ))}
        </div>
      </div>
    </div>
  )
}

function DiaryForm({ onClose, onSave }) {
  const [memo, setMemo] = useState('')
  const [result, setResult] = useState(3)
  const [selectedMood, setSelectedMood] = useState('😊')

  const handleSave = () => {
    if (!memo.trim()) return
    onSave({
      id: Date.now(),
      date: new Date().toISOString().slice(0, 10),
      mood: selectedMood,
      routine: ['오늘의 루틴'],
      result: `${result}/5`,
      memo,
      tags: [],
    })
  }

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-sheet" onClick={e => e.stopPropagation()}>
        <div className="modal-handle" />
        <h3 style={{ marginBottom: 20 }}>오늘의 헤어 기록 ✍️</h3>

        {/* Mood */}
        <p style={{ fontSize: 13, fontWeight: 600, color: '#3D2B1F', marginBottom: 8 }}>오늘 기분</p>
        <div style={{ display: 'flex', gap: 10, marginBottom: 18 }}>
          {['😞','😕','😐','😊','🥰'].map(m => (
            <button key={m} onClick={() => setSelectedMood(m)} style={{
              flex: 1, fontSize: 24, padding: '8px 4px', borderRadius: 10, border: 'none',
              background: selectedMood === m ? '#FDEEE8' : '#F5EBE5',
              cursor: 'pointer',
              boxShadow: selectedMood === m ? '0 0 0 2px #F2A58E' : 'none',
              transition: 'all 0.15s',
            }}>{m}</button>
          ))}
        </div>

        {/* Result rating */}
        <p style={{ fontSize: 13, fontWeight: 600, color: '#3D2B1F', marginBottom: 8 }}>
          오늘 컬 상태: <span style={{ color: '#F2A58E' }}>{result}/5</span>
        </p>
        <input
          type="range" min={1} max={5} value={result}
          onChange={e => setResult(Number(e.target.value))}
          style={{ width: '100%', marginBottom: 18, accentColor: '#F2A58E' }}
        />

        {/* Memo */}
        <p style={{ fontSize: 13, fontWeight: 600, color: '#3D2B1F', marginBottom: 8 }}>메모</p>
        <textarea
          value={memo}
          onChange={e => setMemo(e.target.value)}
          placeholder="오늘의 루틴과 느낌을 자유롭게 적어봐요 🌿"
          className="input-field"
          rows={4}
          style={{ resize: 'none', marginBottom: 20 }}
        />

        <div style={{ display: 'flex', gap: 10 }}>
          <button className="btn btn-secondary" style={{ flex: 1 }} onClick={onClose}>취소</button>
          <button className="btn btn-primary" style={{ flex: 2 }} onClick={handleSave}>저장하기 ✨</button>
        </div>
      </div>
    </div>
  )
}
