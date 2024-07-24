import { createContext, useState, ReactNode, useEffect } from "react";
import { Params, redirect } from "react-router-dom";

interface AuthState {
  isAuthenticated: boolean;
}

interface AuthSecrets {
    sessionToken: string;
    renewToken: string;
}

interface fetchTokenSuccessResult {
    token: string;
}

interface fetchTokenErrorResult {
    error: string;
}

type fetchTokenResult = fetchTokenSuccessResult | fetchTokenErrorResult;

interface logoutSuccessResult {
    message: string;
}

interface logoutErrorResult {
    error: string;
}

type logoutResult = logoutSuccessResult | logoutErrorResult;

const AuthContext = createContext<{
  authState: AuthState;
  authSecrets: AuthSecrets;
}>({
    authState: { isAuthenticated: false },
    authSecrets: { sessionToken: "", renewToken: "" }
});

export function fetchSessionToken(renewToken: string) {
    return fetch("/api/auth/fetchSessionToken", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${renewToken}`,
        },
    })
    .then((response) => response.json())
    .then((result: fetchTokenResult) => {
        return result;
    })
    .catch((error) => {
        console.log(`Error fetching session token: ${error.message}`);
        return { fetchError: error.message }
    });
}

export async function login(params: Params<string>) {
    const sessionToken = params.get??("sessionToken");
    const sessionExpireTime = params.get??("sessionExpireTime");
    const renewToken = params.get??("renewToken");

    // Remove the tokens from the URL
    window.history.replaceState({}, document.title, window.location.pathname);

    if (sessionToken && renewToken && sessionExpireTime) {
        localStorage.setItem("sessionToken", sessionToken);
        localStorage.setItem("sessionExpireTime", sessionExpireTime);
        localStorage.setItem("renewToken", renewToken);

        redirect("/webapp");
    }
    else {
        redirect("/");
    }
}

export function logout(renewToken: string) {
    return fetch("/api/auth/logout", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${renewToken}`,
        },
    })
    .then((response) => response.json())
    .then((result: logoutResult) => {
        return result;
    })
    .catch((error) => {
        console.log(`Error logging out: ${error.message}`);
        return { logoutError: error.message }
    });
}

export function renewSessionToken(renewToken: string) {
    return fetch("/api/auth/renewSessionToken", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${renewToken}`,
        },
    })
    .then((response) => response.json())
    .then((result: fetchTokenResult) => {
        return result;
    })
    .catch((error) => {
        console.log(`Error renewing session token: ${error.message}`)
        return { fetchError: error.message }
    });
}

export function AuthProvider(children: ReactNode) {
    const [authState, setAuthState] = useState<AuthState>({ isAuthenticated: false });
    const [authSecrets, setAuthSecrets] = useState<AuthSecrets>({ sessionToken: "", renewToken: "" });

    useEffect(() => {
        const sessionToken = localStorage.getItem("sessionToken");
        const renewToken = localStorage.getItem("renewToken");

        if (sessionToken && renewToken) {
            setAuthState({ isAuthenticated: true });
            setAuthSecrets({ sessionToken, renewToken });
        }
        else if (renewToken) {
            fetchSessionToken(renewToken)
            .then((result) => {

                if ("token" in result) {
                    setAuthState({ isAuthenticated: true });
                    setAuthSecrets({ sessionToken: result.token, renewToken });
                    localStorage.setItem("sessionToken", result.token);
                }
                else if ("error" in result) {
                    setAuthState({ isAuthenticated: false });
                    setAuthSecrets({ sessionToken: "", renewToken: "" });
                }
                else if ("fetchError" in result) {
                    console.log(`Error fetching session token: ${result.fetchError}`);
                }
                else {
                    console.log("Unknown error fetching session token");
                }
            });
        }
    }, []);
}