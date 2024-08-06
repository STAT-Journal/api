import { useNavigate, useOutlet } from "react-router-dom";
import TopBar from "../components/TopBar";
import { useEffect } from "react";
import { AuthBlob } from "../gql/codegen/graphql";
import { CurrentUserProvider } from "../providers/CurrentUser";
import {  } from "../providers/Graphql";
import { Layout } from "antd";

export interface RootProps {
    setRefreshData: (data: AuthBlob | null) => void;
    refreshData: AuthBlob | null;
}

export default function Root() {
    const outlet = useOutlet();
    const navigate = useNavigate();    

    useEffect(() => {
        if (outlet === null) {
            navigate("/feed");
        }
    }, [outlet]);

    const { Header, Content } = Layout;

    return ( 
        <CurrentUserProvider>
            <Layout>
                <Header style={{display: "flex"}}>
                    <TopBar />
                </Header>
                <Content style={{ padding: "24px 48px" }}>
                    <div style={{ margin: "auto", maxWidth: "50%", padding: 24, minHeight: "80rem", borderRadius: 10, backgroundColor: "white" }}>
                        {outlet}
                    </div>
                </Content>
            </Layout>
        </CurrentUserProvider>
    );
}