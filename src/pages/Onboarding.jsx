import React, { useState } from 'react'
import { CURL_TYPES } from '../data'

export default function Onboarding({ onComplete }) {
  const [step, setStep] = useState(0) // 0=splash, 1=welcome, 2=curl select
  const [selected, setSelected] = useState(null)

  if (step === 0) return <Splash onNext={() => setStep(1)} />
  if (step === 1) return <Welcome onNext={() => setStep(2)} />
  return (
    <CurlSelect
      selected={selected}
      onSelect={setSelected}
      onComplete={() => selected && onComplete(selected)}
    />
  )
}

function Splash({ onNext }) {
  React.useEffect(() => {
    const t = setTimeout(onNext, 2200)
    return () => clearTimeout(t)
  }, [onNext])

  return (
    <div style={{
      display: 'flex', flexDirection: 'column', alignItems: 'center',
      justifyContent: 'center', height: '100dvh',
      background: 'linear-gradient(160deg, #FFF8EF 0%, #FDEEE8 100%)',
    }}>
      <div style={{ animation: 'splashBounce 0.8s ease-out' }}>
        <img src="/logo.png" alt="꼬불랑 로고" style={{ width: 180, height: 180, objectFit: 'contain', objectPosition: 'right center' }} />
      </div>
      <h1 style={{ fontSize: 28, fontWeight: 800, color: '#3D2B1F', marginTop: 8 }}>꼬불랑</h1>
      <p style={{ color: '#B89585', fontSize: 13, marginTop: 4 }}>내 곱슬에 맞는 케어를 찾아봐요</p>
      <div style={{ marginTop: 40, display: 'flex', gap: 6 }}>
        {[0,1,2].map(i => (
          <div key={i} style={{
            width: 8, height: 8, borderRadius: '50%',
            background: i === 0 ? '#F2A58E' : '#EDD5C5',
            animation: `pulse ${0.6 + i * 0.2}s ease-in-out infinite alternate`,
          }} />
        ))}
      </div>
      <style>{`
        @keyframes splashBounce { from { transform: scale(0.7); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        @keyframes pulse { from { transform: scale(1); } to { transform: scale(1.3); } }
      `}</style>
    </div>
  )
}

function Welcome({ onNext }) {
  return (
    <div style={{
      display: 'flex', flexDirection: 'column', height: '100dvh',
      background: 'linear-gradient(160deg, #FFF8EF 0%, #FDEEE8 60%, #D6F0ED 100%)',
      padding: '60px 28px 40px',
    }}>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}>
        <img src="/logo.png" alt="꼬불랑" style={{ width: 140, objectFit: 'contain', objectPosition: 'right center', marginBottom: 24 }} />
        <h1 style={{ fontSize: 26, fontWeight: 800, lineHeight: 1.4, color: '#3D2B1F' }}>
          안녕하세요! 👋<br/>
          <span style={{ color: '#F2A58E' }}>꼬불랑</span>에 오신 걸 환영해요
        </h1>
        <p style={{ marginTop: 16, fontSize: 15, color: '#7A5C4A', lineHeight: 1.7 }}>
          한국 곱슬머리를 위한<br/>
          케어 정보와 커뮤니티 공간이에요.<br/>
          나만의 루틴을 찾아봐요 🌸
        </p>
        <div style={{ marginTop: 32, display: 'flex', flexDirection: 'column', gap: 12, width: '100%', maxWidth: 280 }}>
          {['💧 내 곱슬 유형에 맞는 제품 추천', '📓 헤어 케어 일지 기록', '🌿 같은 고민 친구들과 소통'].map(item => (
            <div key={item} style={{
              background: 'white', borderRadius: 12, padding: '12px 16px',
              fontSize: 14, color: '#3D2B1F', textAlign: 'left',
              boxShadow: '0 2px 8px rgba(61,43,31,0.08)',
            }}>{item}</div>
          ))}
        </div>
      </div>
      <button className="btn btn-primary btn-full" style={{ fontSize: 16 }} onClick={onNext}>
        시작하기 →
      </button>
    </div>
  )
}

function CurlSelect({ selected, onSelect, onComplete }) {
  const categories = [2, 3, 4]
  const categoryLabels = { 2: '웨이비 (2형)', 3: '컬리 (3형)', 4: '코일리 (4형)' }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100dvh', background: '#FFF8EF' }}>
      <div style={{ padding: '48px 24px 16px' }}>
        <h2 style={{ fontSize: 22, fontWeight: 800, color: '#3D2B1F' }}>내 곱슬 유형은?</h2>
        <p style={{ marginTop: 8, fontSize: 14, color: '#7A5C4A', lineHeight: 1.6 }}>
          모발 상태에 가장 가까운 유형을 선택해주세요.<br/>
          나중에 언제든지 변경할 수 있어요.
        </p>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '0 24px 24px' }}>
        {categories.map(cat => (
          <div key={cat} style={{ marginBottom: 20 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
              <div style={{
                width: 28, height: 28, borderRadius: '50%',
                background: cat === 2 ? '#F5D76E' : cat === 3 ? '#F4A27B' : '#E87070',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 13, fontWeight: 800, color: 'white',
              }}>{cat}</div>
              <span style={{ fontSize: 14, fontWeight: 700, color: '#3D2B1F' }}>{categoryLabels[cat]}</span>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {CURL_TYPES.filter(t => t.category === cat).map(type => (
                <button
                  key={type.id}
                  onClick={() => onSelect(type.id)}
                  style={{
                    display: 'flex', alignItems: 'center', gap: 12,
                    padding: '14px 16px', borderRadius: 14,
                    border: selected === type.id ? '2px solid #F2A58E' : '2px solid transparent',
                    background: selected === type.id ? '#FDEEE8' : 'white',
                    cursor: 'pointer', textAlign: 'left', width: '100%',
                    boxShadow: '0 2px 8px rgba(61,43,31,0.07)',
                    transition: 'all 0.15s ease', fontFamily: 'inherit',
                  }}
                >
                  <div style={{
                    width: 44, height: 44, borderRadius: 12, flexShrink: 0,
                    background: cat === 2 ? '#FFFBE6' : cat === 3 ? '#FFF3EC' : '#FFF0F0',
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    fontSize: 22,
                  }}>{type.emoji}</div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                      <span style={{ fontSize: 15, fontWeight: 700, color: '#3D2B1F' }}>{type.label}</span>
                      <span style={{ fontSize: 12, color: '#7A5C4A' }}>{type.title}</span>
                    </div>
                    <p style={{ fontSize: 12, color: '#B89585', marginTop: 2, lineHeight: 1.4 }}>{type.desc}</p>
                  </div>
                  {selected === type.id && (
                    <div style={{ width: 20, height: 20, borderRadius: '50%', background: '#F2A58E', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                      <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                        <path d="M2 6l3 3 5-5" stroke="white" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
                      </svg>
                    </div>
                  )}
                </button>
              ))}
            </div>
          </div>
        ))}
      </div>

      <div style={{ padding: '12px 24px 32px', background: '#FFF8EF' }}>
        <button
          className="btn btn-primary btn-full"
          style={{ fontSize: 16, opacity: selected ? 1 : 0.5 }}
          onClick={onComplete}
          disabled={!selected}
        >
          {selected ? `${selected} 유형으로 시작하기 ✨` : '유형을 선택해주세요'}
        </button>
      </div>
    </div>
  )
}
