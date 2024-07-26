import { useEffect } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";

export function LogInTokenHandling() {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    useEffect(() => {
        const renewalToken = searchParams.get("renewal_token");
        const renewalExpiration = searchParams.get("renewal_expiration");
        const sessionToken = searchParams.get("session_token");
        const sessionExpiration = searchParams.get("session_expiration");
        

        // Clear the URL to prevent token leakage
        window.history.replaceState({}, document.title, window.location.pathname);
        
        if (renewalToken && renewalExpiration && sessionToken && sessionExpiration) {
            localStorage.setItem("renewalToken", renewalToken);
            localStorage.setItem("renewalExpiration", renewalExpiration);
            localStorage.setItem("sessionToken", sessionToken);
            localStorage.setItem("sessionExpiration", sessionExpiration);
            
            console.log("Fetched tokens");

            navigate("/");
        } else {
            console.log("Error logging in: missing tokens");
        }
    }, [searchParams]);

    return (
        <div>Fetching Login Information</div>
    )
}