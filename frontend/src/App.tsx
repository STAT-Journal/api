import { RefreshDataProvider } from './providers/AuthDataStorage';
import { CurrentUserProvider } from './providers/CurrentUser';
import { GraphqlProvider } from './providers/Graphql';
import Router from './routes/Router';

function App() {
  return (
    <RefreshDataProvider>
      <GraphqlProvider>
        <Router />
      </GraphqlProvider>
    </RefreshDataProvider>
  )
}

export default App