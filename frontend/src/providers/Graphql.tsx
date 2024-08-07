import { AuthConfig, authExchange, AuthUtilities } from "@urql/exchange-auth";
import { AuthBlob } from "../gql/codegen/graphql";
import { cacheExchange, Client, CombinedError, fetchExchange, Operation, OperationResult, Provider, subscriptionExchange } from "urql";
import { useRefreshData } from "./AuthDataStorage";
import { graphql } from "../gql/codegen";
import { SelectionNode } from "graphql";
import { useEffect, useState } from "react";
import * as withAbsintheSocket from "@absinthe/socket";
import { Channel, Socket as PhoenixSocket } from "phoenix";
import { make, pipe, toObservable } from 'wonka'




export function GraphqlProvider({ children }: { children: React.ReactNode }) {
    const refreshDataContext = useRefreshData();
    const refreshData = refreshDataContext.authData;
    const setRefreshData = refreshDataContext.setAuthData;
    const [accessData, setAccessData] = useState<AuthBlob | null>(null);

    const phoenixSockeWsUrl = window.location.origin.replace(/^http/, 'ws') + '/socket';
    

    // TODO: may need to put this in a useEffect
    const socket = new PhoenixSocket(phoenixSockeWsUrl, {
        params: () => {
            return {
                authorization: `Bearer ${accessData?.token}`
            }
        }
    });
    socket.connect()
    const absintheChannel = socket.channel('__absinthe__:control')
    absintheChannel.join()

    const absintheExchange = subscriptionExchange({
        forwardSubscription({ query, variables }) {
          let subscriptionChannel: Channel
      
          const source = make((observer) => {
            const { next } = observer
      
            absintheChannel.push('doc', { query, variables }).receive('ok', (v) => {
              const subscriptionId = v.subscriptionId
      
              if (subscriptionId) {
                subscriptionChannel = socket.channel(subscriptionId)
                subscriptionChannel.on('subscription:data', (value) => {
                  next(value.result)
                })
              }
            })
      
            return () => {
              subscriptionChannel?.leave()
            }
          })
      
          return pipe(source, toObservable)
        },
      })
    
    async function authExchangeConfiguration(utils: AuthUtilities): Promise<AuthConfig> {        
        return {
        addAuthToOperation(operation: Operation) {
            if (accessData && accessData.token) {
                console.log('Adding auth to operation', accessData);
            return utils.appendHeaders(operation, 
                { authorization: `Bearer ${accessData.token}` }
            );
            } else {
            return operation;
            }
        },
        didAuthError(error: CombinedError, _operation: Operation) {
            let result = error.graphQLErrors.some(e => 
            e.message === 'Invalid Authentication' || e.message === "Please log in first"
            );
            console.log('didAuthError', result);
            return result;

            
        },
        willAuthError(operation: Operation) {
            if (!accessData || !accessData.token) {
            // register does not require authentication
            // all other operations do
            // so if operation includes register, will not error
            return !operation
            .query
            .definitions
            .some(def => 
                def.kind === 'OperationDefinition' &&
                def.operation === 'mutation' &&
                def.selectionSet.selections.some(
                (s: SelectionNode) => s.kind === 'Field' && s.name.value === 'register'
                )
            );
            } else {
                let seconds_since_epoch = Math.round(Date.now() / 1000);
                let result = accessData.claims.exp < seconds_since_epoch;
                console.log('willAuthError', result);
                return result;
            }
        },
        async refreshAuth() {
            const mutation = graphql(`mutation exchangeRefreshForAccessToken($refreshToken: String!) {\n  exchangeRefreshForAccessToken(refreshToken: $refreshToken) {\n    token\n    claims {\n      sub\n      exp\n      iat\n    }\n  }\n}`);
    
            if (refreshData && refreshData.token) {
                return utils.mutate(mutation, { refreshToken: refreshData.token })
                .then((result: OperationResult) => {
                    if (result.error) {
                        console.log("GraphqlProvider: refreshAuth: error", result);
                        setRefreshData(null);
                    }
                    else if (result.data.exchangeRefreshForAccessToken) {
                        console.log("GraphqlProvider: refreshAuth: success", result.data);
                        setAccessData(result.data.exchangeRefreshForAccessToken);
                    }
                });
            }
            else {
                console.log('No refresh token available');
                return Promise.resolve();
            }
        },
        }
    }

    const client = new Client({
        url: '/api/graphql',
        exchanges: [
        cacheExchange,
        authExchange(authExchangeConfiguration),
        fetchExchange,
        absintheExchange
        ]
    })


    return (
        <Provider value={client}>
            {children}
        </Provider>
    )
}
