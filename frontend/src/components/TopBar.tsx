import { Avatar, Menu } from "antd";
import { MenuItemType } from "antd/es/menu/interface";
import { useLocation, useNavigate } from "react-router-dom";
import { CurrentUserContext } from "../providers/CurrentUser";
import { useContext, useEffect, useState } from "react";

export default function TopBar() {
    const navigate = useNavigate();
    const currentUserContext = useContext(CurrentUserContext);
    const [profileIcon, setProfileIcon] = useState<JSX.Element | null>(null);
    const selectedKey = useLocation().pathname;

    useEffect(() => {
        setProfileIcon(
            <Avatar 
            src={currentUserContext.avatarImageUri} 
            style={{alignSelf: "center", cursor: "pointer"}}
            onClick={() => navigate("/profile")}
            />
        );

        console.log("CurrentUserContext: ", currentUserContext);
    }, [currentUserContext]);


    const items: MenuItemType[] = [
        { key: "/feed", label: "Feed", onClick: () => navigate("/feed") },
        { key: "/reflection", label: "Reflection", onClick: () => navigate("/reflection") },
    ]
    return (
        <>  
            <Menu selectedKeys={[selectedKey]} style={{ flex: 1, minWidth: 0 }} theme="dark" mode="horizontal" items={items} />
            {profileIcon}
        </>
    )
}