import { useEffect, useState } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import { AuthBlob } from "../gql/codegen/graphql";
import { useRefreshData } from "../providers/AuthDataStorage";

export interface LogInTokenHandlingProps {
    setRefreshData: (data: AuthBlob) => void;
}

export function LogInTokenHandling() {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const [message, setMessage] = useState<string>("Fetching Login Information");
    const refreshDataContext = useRefreshData();
    const setRefreshData = refreshDataContext.setAuthData;

    useEffect(() => {
        const refreshToken = searchParams.get("token");
        const refreshClaims = searchParams.get("claims");

        // Clear the URL to prevent token leakage
        window.history.replaceState({}, document.title, window.location.pathname);
        
        if (refreshToken && refreshClaims) {
            const authBlob: AuthBlob = {
                token: refreshToken,
                claims: JSON.parse(refreshClaims)
            };

            setRefreshData(authBlob);
            
            console.log("Fetched tokens: ", authBlob);

            navigate("/feed");
        } else {
            console.log("Error logging in: missing tokens");
        }
    }, [searchParams]);

    return (
        <div>{message}</div>
    )
}