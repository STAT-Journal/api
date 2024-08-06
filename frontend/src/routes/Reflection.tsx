import { useMutation, useQuery } from "urql";
import { graphql } from "../gql/codegen";
import { Button, Input, Timeline } from "antd";
import { TextPost } from "../gql/codegen/graphql";
import { useState } from "react";
import { useNotification } from "../providers/Notification";

export default function Reflection() {
    const reflectionQuery = graphql(`query listTextPosts {\n  listTextPosts {\n    body\n    insertedAt\n  }\n}`);
    const [reflectionResult,_] = useQuery({ query: reflectionQuery});
    const [newTextPostData, setNewTextPostData] = useState({body: ""});
    const [_newTextPostMutationResult, newTextPost] = useMutation(graphql(`mutation createTextPost($body: String!) {\n  createTextPost(body: $body) {\n    body\n  }\n}`));
    const {api} = useNotification();
    const handleTextPostChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
        setNewTextPostData({body: e.target.value});
    }

    const handleTextPostSubmit = () => {
        newTextPost({body: newTextPostData.body})
        .then((result) => {
            if (result.error) {
                api.error({message: "Failed to submit text post", description: result.error.message});
            } else {
                api.success({message: "Successfully submitted text post"});
                setNewTextPostData({body: ""});
            }
        });
    }

    return (
        <>
        <Input.TextArea value={newTextPostData.body} onChange={handleTextPostChange} placeholder="Write your reflection here" />
        <Button onClick={handleTextPostSubmit}>Submit</Button>
        <Timeline>
            {reflectionResult.data?.listTextPosts?.map((post: TextPost) => {
                return (
                    <Timeline.Item>
                        <p>{post.body}</p>
                        <p>{post.insertedAt}</p>
                    </Timeline.Item>
            )})}
        </Timeline>
        </>
    );
}