import React, { useState } from 'react'
import Onboarding from './pages/Onboarding'
import Home from './pages/Home'
import Products from './pages/Products'
import Diary from './pages/Diary'
import Community from './pages/Community'
import Profile from './pages/Profile'
import BottomNav from './components/BottomNav'

export default function App() {
  const [curlType, setCurlType] = useState(null) // null = onboarding
  const [tab, setTab] = useState('home')

  if (!curlType) {
    return (
      <div className="app-shell">
        <Onboarding onComplete={(type) => { setCurlType(type); setTab('home') }} />
      </div>
    )
  }

  const renderTab = () => {
    switch (tab) {
      case 'home':      return <Home curlType={curlType} onNavigate={setTab} />
      case 'products':  return <Products curlType={curlType} />
      case 'diary':     return <Diary />
      case 'community': return <Community curlType={curlType} />
      case 'profile':   return <Profile curlType={curlType} onChangeCurlType={setCurlType} />
      default:          return <Home curlType={curlType} onNavigate={setTab} />
    }
  }

  return (
    <div className="app-shell">
      {renderTab()}
      <BottomNav active={tab} onNavigate={setTab} />
    </div>
  )
}
