import { useState } from 'react'
import { Card, Button } from 'flowbite-react';
import './App.css'
import TopBar from './components/TopBar';

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
    <TopBar />
    </>
  )
}

export default App
