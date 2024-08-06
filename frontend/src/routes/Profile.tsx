import { useContext, useEffect, useState } from "react";
import { CurrentUserContext } from "../providers/CurrentUser";
import { Button, Card, Form, Input, QRCode } from "antd";
import { graphql } from "../gql/codegen";
import { useQuery } from "urql";
import { useNotification } from "../providers/Notification";
import { PublicUser } from "../gql/codegen/graphql";
import { getAvatarImageUri } from "../components/AvatarImage";

const FollowCard = ({publicUser}: {publicUser: PublicUser}) => {
    const [avatarUri, setAvatarUri] = useState<string | undefined>(undefined);

    useEffect(() => {
        if (publicUser.avatar) {
            getAvatarImageUri(publicUser.avatar).then(setAvatarUri);
        }
    }, [publicUser]);

    return (
        <Card style={{
            maxWidth: "5rem",
            display: "flex",
            flexDirection: "column",
            margin: "auto",
            alignItems: "center",
        }}
        title={publicUser.username}
        cover={<img src={avatarUri} style={{height: "5rem"}} />}
        >
        </Card>
    )
}

const FollowCardList = ({publicUsers}: {publicUsers: PublicUser[]}) => {
    if (publicUsers.length === 0) {
        return <p>No users to show</p>
    }
    else {
        return (
            publicUsers.map((publicUser) => <FollowCard publicUser={publicUser} />)
        )
    }
}

export function Profile() {
    const currentUserContext = useContext(CurrentUserContext);
    const avatar = <img src={currentUserContext.avatarImageUri} style={{height: "10rem"}} />;
    const username = currentUserContext.me?.public?.username;
    const query = graphql(`query getFollowToken {\n  getFollowToken\n}`)
    const [followToken, _reFT] = useQuery({query: query, requestPolicy: "cache-first"})
    const {api} = useNotification();

    const getFollowersAndFollowingQuery = graphql(`query getFollowersAndFollowing {\n  getFollowers {\n    avatar {\n      options\n      style\n    }\n    username\n  }\n  getFollowing {\n    avatar {\n      options\n      style\n    }\n    username\n  }\n}`);
    const [followersAndFollowing, _reFAF] = useQuery({query: getFollowersAndFollowingQuery, requestPolicy: "cache-and-network"});

    const followUrl = window.location.origin + "/follow/" + followToken.data?.getFollowToken;

    const copyFollowUrl = () => {
        navigator.clipboard.writeText(followUrl);
        api.success({
            message: "Copied Follow Link",
            description: "You can now share this link with others to allow them to follow"
        })
    }

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
                
                <Form layout="vertical">
                    <Form.Item>
                        <Button onClick={currentUserContext.logout}>Logout</Button>
                    </Form.Item>
                    <Form.Item label="Follow Link">
                        <Input readOnly value={followUrl} />
                        <Button onClick={copyFollowUrl}>Copy Follow Link</Button>
                    </Form.Item>
                    <Form.Item label="QR Code">
                        You can also show this QR code to allow others to follow you:
                        <QRCode value={followUrl} />
                    </Form.Item>
                </Form>
            </Card>
            <h2>Followers</h2>
            <div style={{ display: "flex", justifyContent: "start", marginTop: "1rem", flexDirection: "row" }}>
                <FollowCardList publicUsers={followersAndFollowing.data?.getFollowers??[]} />
            </div>
            <h2>Following</h2>
            <div style={{ display: "flex", justifyContent: "start", marginTop: "1rem", flexDirection: "row" }}>
                <FollowCardList publicUsers={followersAndFollowing.data?.getFollowing?? []} />
            </div>
        </>
    )
}