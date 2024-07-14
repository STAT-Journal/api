import { useNavigate, useOutlet } from "react-router-dom";
import TopBar from "../components/TopBar";
import { useEffect } from "react";

export default function Root() {
    const outlet = useOutlet();
    const navigate = useNavigate();


    useEffect(() => {
        if (outlet === null) {
            navigate("/feed");
        }
    }, [outlet, navigate]);

    return (
        <>
            <TopBar />
            <div className="mx-auto max-w-lg">
                {outlet}
            </div>
        </>
    );
}