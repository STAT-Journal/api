import { createContext, useContext, useState } from "react";
import { AuthBlob } from "../gql/codegen/graphql";

function isAuthBlob(obj: AuthBlob) {
    return obj.token && obj.claims && obj.claims.exp && obj.claims.iat && obj.claims.sub;
}

function getRefreshDataFromLocalStorage(): AuthBlob | null {
    let refreshJson = localStorage.getItem('refreshTokenJson');
    if (refreshJson) {
      let parsed = JSON.parse(refreshJson) as AuthBlob;
      return isAuthBlob(parsed) ? parsed : null;
    } else {
      return null;
    }
  }

  function setRefreshDataToLocalStorage(data: AuthBlob) {
    localStorage.setItem('refreshTokenJson', JSON.stringify(data));
  }

interface AuthDataContext {
    authData: AuthBlob | null;
    setAuthData: (authData: AuthBlob | null) => void;
}

const refreshDataContext = createContext<AuthDataContext>({
    authData: null,
    setAuthData: () => {}
});

export function RefreshDataProvider({ children }: { children: React.ReactNode }) {
    const [refreshData, setRefreshData] = useState<AuthBlob | null>(getRefreshDataFromLocalStorage());

    const setRefreshDataWithLocalStorage = (data: AuthBlob | null) => {
        if (data) {
            setRefreshDataToLocalStorage(data);
        } else {
            localStorage.removeItem('refreshTokenJson');
        }
        setRefreshData(data);
        console.log("Setting refresh data: ", data);
    };

    return (
        <refreshDataContext.Provider value={{ authData: refreshData, setAuthData: setRefreshDataWithLocalStorage }}>
            {children}
        </refreshDataContext.Provider>
    )
}

export function useRefreshData() {
    return useContext(refreshDataContext);
}