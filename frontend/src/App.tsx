import { RefreshDataProvider } from './providers/AuthDataStorage';
import { CurrentUserProvider } from './providers/CurrentUser';
import { GraphqlProvider } from './providers/Graphql';
import { NotificationProvider } from './providers/Notification';
import Router from './routes/Router';

function App() {
  return (
    <NotificationProvider>
      <RefreshDataProvider>
        <GraphqlProvider>
          <Router />
        </GraphqlProvider>
      </RefreshDataProvider>
    </NotificationProvider>
  )
}

export default App