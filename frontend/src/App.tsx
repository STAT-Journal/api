import { cacheExchange, Client, fetchExchange, Provider } from 'urql';
import { AuthConfig, authExchange, AuthUtilities } from '@urql/exchange-auth';
import { graphql } from './gql/codegen';
import Router from './routes/Router';



async function authExchangeConfiguration(utils: AuthUtilities): Promise<AuthConfig> {
  let sessionToken = localStorage.getItem('sessionToken');
  // let sessionTokenExpiryEpoch = localStorage.getItem('sessionTokenExpiry');
  // let sessionTokenExpiry = new Date(sessionTokenExpiryEpoch || 0);
  let renewalToken = localStorage.getItem('renewalToken');
  // let renewalTokenExpiryEpoch = localStorage.getItem('renewalTokenExpiry');
  // let renewalTokenExpiry = new Date(renewalTokenExpiryEpoch || 0);


  return {
    addAuthToOperation(operation: any) {
      if (!sessionToken) {
        return operation;
      } else {
        return utils.appendHeaders(operation, 
          { Authorization: `Bearer ${sessionToken}` }
        );
      }
    },
    didAuthError({ }: any) {
      return false;
    },
    willAuthError({ }: any) {
      return false;
    },
    refreshAuth() {
      const mutation = graphql(`mutation getSessionToken($renewalToken: String!) {\n  getSessionToken(renewalToken: $renewalToken)\n}`);

      if (!renewalToken) {
        // TODO: Handle logout
        console.log('No renewal token');
        return Promise.resolve();
      } else {
        return utils.mutate(mutation, { renewalToken })
        .then((result) => {
          if (result.data?.getSessionToken) {
            localStorage.setItem('sessionToken', result.data.getSessionToken);
          } else {
            localStorage.removeItem('sessionToken');
          }
        })
        .finally(() => {
          if (!localStorage.getItem('sessionToken')) {
            console.log('Error refreshing session token');
            // TODO: Handle logout
          }
        })
      }
    },
  }
}

const client = new Client({
  url: '/api/graphql',
  exchanges: [
    cacheExchange,
    authExchange(authExchangeConfiguration),
    fetchExchange
  ],
})


function App() {
  return (
    <Provider value={client}>
      <Router />
    </Provider>
  )
}

export default App