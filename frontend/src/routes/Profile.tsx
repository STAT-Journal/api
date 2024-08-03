import { useContext } from "react";
import { CurrentUserContext } from "../providers/CurrentUser";
import { Button, Card } from "antd";

export function Profile() {
    const currentUserContext = useContext(CurrentUserContext);
    const avatar = <img src={currentUserContext.avatarImageUri} style={{height: "10rem"}} />;
    const username = currentUserContext.me?.public?.username;
    return (
        <>
            <Card style={{
                width: "70%", 
                display: "flex", 
                flexDirection: "column", 
                margin: "auto", 
                alignItems: "center"}} 
                title={username}
                cover={avatar}>
                <Button onClick={currentUserContext.logout}>Logout</Button>
            </Card>
            
        </>
    )
}