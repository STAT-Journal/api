import { cacheExchange, Client, fetchExchange, Provider } from 'urql';
import { authExchange } from '@urql/exchange-auth';
import Router from './routes/Router';




const client = new Client({
  url: '/api/graphql',
  exchanges: [cacheExchange, fetchExchange],
})

function App() {
  return (
    <Provider value={client}>
      <Router />
    </Provider>
  )
}

export default App